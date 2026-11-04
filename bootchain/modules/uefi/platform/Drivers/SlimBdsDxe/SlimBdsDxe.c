/** @file
  Slim BDS for the Radxa Orion O6.

  Produces the BDS architectural protocol and does only what is needed to hand off to an OS loader:
    1. Perform the platform handshakes that the stock BDS/PlatformBootManagerLib performed (EndOfDxe,
       ReadyToBoot, firmware identification in the system table).
    2. Connect the PCIe root bridges and boot the Windows boot manager from the NVMe EFI system partition.
    3. Only if that fails, load the fallback tier (USB, display, console, HII, shell) from the firmware
       volume and run the fallback application, which handles USB boot and the UEFI shell.

  SPDX-License-Identifier: BSD-2-Clause-Patent
**/

#include <Uefi.h>
#include <Protocol/Bds.h>
#include <Protocol/DevicePath.h>
#include <Protocol/FirmwareVolume2.h>
#include <Protocol/LoadedImage.h>
#include <Protocol/PciRootBridgeIo.h>
#include <Protocol/SimpleFileSystem.h>
#include <Guid/EventGroup.h>
#include <Library/BaseLib.h>
#include <Library/BaseMemoryLib.h>
#include <Library/DebugLib.h>
#include <Library/DevicePathLib.h>
#include <Library/MemoryAllocationLib.h>
#include <Library/PcdLib.h>
#include <Library/UefiBootServicesTableLib.h>
#include <Library/UefiDriverEntryPoint.h>
#include <Library/UefiLib.h>
#include "SlimBdsFallback.h"

#define NVME_SCAN_ATTEMPTS    5
#define NVME_SCAN_RETRY_US    1000000
#define BOOT_WATCHDOG_SECONDS (5 * 60)

STATIC CONST CHAR16  *mOsLoaderFiles[] = {
  L"\\EFI\\Microsoft\\Boot\\bootmgfw.efi",
  L"\\EFI\\BOOT\\BOOTAA64.EFI"
};

STATIC BOOLEAN  mReadyToBootSignaled = FALSE;

STATIC
BOOLEAN
PathHasNode (
  IN EFI_DEVICE_PATH_PROTOCOL  *Path,
  IN UINT8                     Type,
  IN UINT8                     SubType
  )
{
  while ((Path != NULL) && !IsDevicePathEnd (Path)) {
    if ((DevicePathType (Path) == Type) && (DevicePathSubType (Path) == SubType)) {
      return TRUE;
    }

    Path = NextDevicePathNode (Path);
  }

  return FALSE;
}

STATIC
VOID
ConnectPciRoots (
  VOID
  )
{
  EFI_STATUS  Status;
  EFI_HANDLE  *Handles;
  UINTN       Count;
  UINTN       Index;

  Status = gBS->LocateHandleBuffer (ByProtocol, &gEfiPciRootBridgeIoProtocolGuid, NULL, &Count, &Handles);
  if (EFI_ERROR (Status)) {
    return;
  }

  for (Index = 0; Index < Count; Index++) {
    gBS->ConnectController (Handles[Index], NULL, NULL, TRUE);
  }

  FreePool (Handles);
}

STATIC
VOID
PublishFirmwareIdentity (
  VOID
  )
{
  CHAR16  *Vendor;

  Vendor = AllocateRuntimeCopyPool (StrSize ((CHAR16 *)PcdGetPtr (PcdFirmwareVendor)), PcdGetPtr (PcdFirmwareVendor));
  if (Vendor != NULL) {
    gST->FirmwareVendor = Vendor;
  }

  gST->FirmwareRevision = PcdGet32 (PcdFirmwareRevision);
  gST->Hdr.CRC32        = 0;
  gBS->CalculateCrc32 ((VOID *)gST, sizeof (EFI_SYSTEM_TABLE), &gST->Hdr.CRC32);
}

/**
  Load and start an image.  Returns the LoadImage status if the image could not be loaded, otherwise the
  status the image returned from StartImage (an OS loader normally never returns).

  @param[in]  BootOption  TRUE for an OS loader started directly by the boot manager: signals ReadyToBoot, runs
                          it with the UEFI boot watchdog armed and no parent handle, as the stock BDS does.
**/
STATIC
EFI_STATUS
LoadAndStart (
  IN  EFI_DEVICE_PATH_PROTOCOL  *FilePath,
  IN  BOOLEAN                   BootOption,
  OUT BOOLEAN                   *Loaded
  )
{
  EFI_STATUS                 Status;
  EFI_HANDLE                 Image;
  EFI_LOADED_IMAGE_PROTOCOL  *LoadedImage;
  UINTN                      ExitDataSize;
  CHAR16                     *ExitData;

  *Loaded = FALSE;
  Status  = gBS->LoadImage (BootOption, gImageHandle, FilePath, NULL, 0, &Image);
  if (EFI_ERROR (Status)) {
    return Status;
  }

  *Loaded = TRUE;

  if (BootOption) {
    // ACPI tables are finalized by ReadyToBoot callbacks, so this must precede any OS loader.
    if (!mReadyToBootSignaled) {
      mReadyToBootSignaled = TRUE;
      EfiSignalEventReadyToBoot ();
    }

    if (!EFI_ERROR (gBS->HandleProtocol (Image, &gEfiLoadedImageProtocolGuid, (VOID **)&LoadedImage))) {
      LoadedImage->ParentHandle = NULL;
    }

    gBS->SetWatchdogTimer (BOOT_WATCHDOG_SECONDS, 0, 0, NULL);
  }

  // The core unloads applications and failed images itself; a driver that returned success must stay resident.
  ExitData = NULL;
  Status   = gBS->StartImage (Image, &ExitDataSize, &ExitData);
  if (ExitData != NULL) {
    FreePool (ExitData);
  }

  if (BootOption) {
    gBS->SetWatchdogTimer (0, 0, 0, NULL);
  }

  return Status;
}

/**
  Try the OS loader files on every NVMe file system.

  @param[out] Found  TRUE if at least one NVMe file system was present.
**/
STATIC
VOID
BootFromNvme (
  OUT BOOLEAN  *Found
  )
{
  EFI_STATUS                Status;
  EFI_HANDLE                *Handles;
  UINTN                     Count;
  UINTN                     Index;
  UINTN                     FileIndex;
  EFI_DEVICE_PATH_PROTOCOL  *FilePath;
  BOOLEAN                   Loaded;

  *Found = FALSE;
  Status = gBS->LocateHandleBuffer (ByProtocol, &gEfiSimpleFileSystemProtocolGuid, NULL, &Count, &Handles);
  if (EFI_ERROR (Status)) {
    return;
  }

  for (Index = 0; Index < Count; Index++) {
    if (!PathHasNode (DevicePathFromHandle (Handles[Index]), MESSAGING_DEVICE_PATH, MSG_NVME_NAMESPACE_DP)) {
      continue;
    }

    *Found = TRUE;
    for (FileIndex = 0; FileIndex < ARRAY_SIZE (mOsLoaderFiles); FileIndex++) {
      FilePath = FileDevicePath (Handles[Index], mOsLoaderFiles[FileIndex]);
      if (FilePath == NULL) {
        continue;
      }

      DEBUG ((DEBUG_INFO, "[SlimBds] NVMe boot: %s\n", mOsLoaderFiles[FileIndex]));
      Status = LoadAndStart (FilePath, TRUE, &Loaded);
      FreePool (FilePath);
      DEBUG ((DEBUG_ERROR, "[SlimBds] NVMe boot: %s %a: %r\n", mOsLoaderFiles[FileIndex], Loaded ? "returned" : "not loaded", Status));
    }
  }

  FreePool (Handles);
}

STATIC
EFI_STATUS
StartFirmwareVolumeFile (
  IN CONST EFI_GUID  *FileGuid
  )
{
  EFI_STATUS                         Status;
  EFI_HANDLE                         *Handles;
  UINTN                              Count;
  UINTN                              Index;
  EFI_FIRMWARE_VOLUME2_PROTOCOL      *Fv;
  UINTN                              Size;
  EFI_FV_FILETYPE                    Type;
  EFI_FV_FILE_ATTRIBUTES             Attributes;
  UINT32                             AuthStatus;
  MEDIA_FW_VOL_FILEPATH_DEVICE_PATH  FileNode;
  EFI_DEVICE_PATH_PROTOCOL           *FilePath;
  BOOLEAN                            Loaded;

  Status = gBS->LocateHandleBuffer (ByProtocol, &gEfiFirmwareVolume2ProtocolGuid, NULL, &Count, &Handles);
  if (EFI_ERROR (Status)) {
    return Status;
  }

  Status = EFI_NOT_FOUND;
  for (Index = 0; Index < Count; Index++) {
    if (EFI_ERROR (gBS->HandleProtocol (Handles[Index], &gEfiFirmwareVolume2ProtocolGuid, (VOID **)&Fv))) {
      continue;
    }

    if (EFI_ERROR (Fv->ReadFile (Fv, FileGuid, NULL, &Size, &Type, &Attributes, &AuthStatus))) {
      continue;
    }

    EfiInitializeFwVolDevicepathNode (&FileNode, FileGuid);
    FilePath = AppendDevicePathNode (DevicePathFromHandle (Handles[Index]), (EFI_DEVICE_PATH_PROTOCOL *)&FileNode);
    if (FilePath == NULL) {
      Status = EFI_OUT_OF_RESOURCES;
      break;
    }

    Status = LoadAndStart (FilePath, FALSE, &Loaded);
    FreePool (FilePath);
    break;
  }

  FreePool (Handles);
  return Status;
}

STATIC
VOID
RunFallback (
  VOID
  )
{
  EFI_STATUS  Status;
  UINTN       Index;

  for (Index = 0; Index < ARRAY_SIZE (mFallbackImages); Index++) {
    DEBUG ((DEBUG_INFO, "[SlimBds] Fallback: %a\n", mFallbackImages[Index].Name));
    Status = StartFirmwareVolumeFile (&mFallbackImages[Index].FileGuid);
    if (EFI_ERROR (Status)) {
      DEBUG ((DEBUG_ERROR, "[SlimBds] Fallback: %a failed: %r\n", mFallbackImages[Index].Name, Status));
    }
  }
}

/**
  BDS architectural protocol entry point, called by the DXE core when dispatch is complete.
**/
STATIC
VOID
EFIAPI
SlimBdsEntry (
  IN EFI_BDS_ARCH_PROTOCOL  *This
  )
{
  UINTN    Attempt;
  BOOLEAN  Found;

  DEBUG ((DEBUG_INFO, "[SlimBds] Entry...\n"));
  PublishFirmwareIdentity ();

  // Drivers such as SecureBootDxe act on EndOfDxe, which the platform boot manager used to signal.
  EfiEventGroupSignal (&gEfiEndOfDxeEventGroupGuid);

  for (Attempt = 0; Attempt < NVME_SCAN_ATTEMPTS; Attempt++) {
    ConnectPciRoots ();
    BootFromNvme (&Found);
    if (Found) {
      break;
    }

    gBS->Stall (NVME_SCAN_RETRY_US);
  }

  DEBUG ((DEBUG_ERROR, "[SlimBds] No NVMe OS boot, starting fallback\n"));
  RunFallback ();

  DEBUG ((DEBUG_ERROR, "[SlimBds] Nothing left to boot\n"));
  CpuDeadLoop ();
}

STATIC EFI_BDS_ARCH_PROTOCOL  mBdsArch = {
  SlimBdsEntry
};

EFI_STATUS
EFIAPI
SlimBdsDxeEntryPoint (
  IN EFI_HANDLE        ImageHandle,
  IN EFI_SYSTEM_TABLE  *SystemTable
  )
{
  EFI_HANDLE  Handle;

  Handle = NULL;
  return gBS->InstallProtocolInterface (&Handle, &gEfiBdsArchProtocolGuid, EFI_NATIVE_INTERFACE, &mBdsArch);
}
