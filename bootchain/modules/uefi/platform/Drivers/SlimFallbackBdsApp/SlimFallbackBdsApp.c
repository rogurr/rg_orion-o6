/** @file
  Fallback boot application, started by SlimBdsDxe after the fallback tier drivers are loaded.

  Brings up the display and USB keyboard console, boots from USB media, then runs the UEFI shell.

  SPDX-License-Identifier: BSD-2-Clause-Patent
**/

#include <Uefi.h>
#include <Protocol/DevicePath.h>
#include <Protocol/GraphicsOutput.h>
#include <Protocol/LoadedImage.h>
#include <Protocol/NonDiscoverableDevice.h>
#include <Guid/NonDiscoverableDevice.h>
#include <Library/BaseLib.h>
#include <Library/BaseMemoryLib.h>
#include <Library/DebugLib.h>
#include <Library/DevicePathLib.h>
#include <Library/MemoryAllocationLib.h>
#include <Library/UefiApplicationEntryPoint.h>
#include <Library/UefiBootManagerLib.h>
#include <Library/UefiBootServicesTableLib.h>
#include <Library/UefiLib.h>
#include <Library/UefiRuntimeServicesTableLib.h>

#pragma pack (1)
typedef struct {
  USB_CLASS_DEVICE_PATH       Keyboard;
  EFI_DEVICE_PATH_PROTOCOL    End;
} USB_KEYBOARD_PATH;
#pragma pack ()

// Short-form device path matching any USB HID boot keyboard.
STATIC USB_KEYBOARD_PATH  mUsbKeyboard = {
  {
    {
      MESSAGING_DEVICE_PATH, MSG_USB_CLASS_DP,
      { (UINT8)sizeof (USB_CLASS_DEVICE_PATH), (UINT8)(sizeof (USB_CLASS_DEVICE_PATH) >> 8) }
    },
    0xFFFF, 0xFFFF, 3, 1, 1
  },
  {
    END_DEVICE_PATH_TYPE, END_ENTIRE_DEVICE_PATH_SUBTYPE,
    { (UINT8)sizeof (EFI_DEVICE_PATH_PROTOCOL), 0 }
  }
};

STATIC
BOOLEAN
IsUsbPath (
  IN EFI_DEVICE_PATH_PROTOCOL  *Path
  )
{
  while ((Path != NULL) && !IsDevicePathEnd (Path)) {
    if ((DevicePathType (Path) == MESSAGING_DEVICE_PATH) &&
        ((DevicePathSubType (Path) == MSG_USB_DP) || (DevicePathSubType (Path) == MSG_USB_CLASS_DP)))
    {
      return TRUE;
    }

    Path = NextDevicePathNode (Path);
  }

  return FALSE;
}

/**
  The core BDS code connects a short-form USB device path by looking for PCI I/O handles whose class is a USB
  host controller, so the non-discoverable USB hosts need the PCI I/O driver attached first.
**/
STATIC
VOID
ConnectUsbHosts (
  VOID
  )
{
  EFI_STATUS               Status;
  EFI_HANDLE               *Handles;
  UINTN                    Count;
  UINTN                    Index;
  NON_DISCOVERABLE_DEVICE  *Device;

  Status = gBS->LocateHandleBuffer (ByProtocol, &gEdkiiNonDiscoverableDeviceProtocolGuid, NULL, &Count, &Handles);
  if (EFI_ERROR (Status)) {
    return;
  }

  for (Index = 0; Index < Count; Index++) {
    if (EFI_ERROR (gBS->HandleProtocol (Handles[Index], &gEdkiiNonDiscoverableDeviceProtocolGuid, (VOID **)&Device))) {
      continue;
    }

    if (CompareGuid (Device->Type, &gEdkiiNonDiscoverableUhciDeviceGuid) ||
        CompareGuid (Device->Type, &gEdkiiNonDiscoverableEhciDeviceGuid) ||
        CompareGuid (Device->Type, &gEdkiiNonDiscoverableXhciDeviceGuid))
    {
      gBS->ConnectController (Handles[Index], NULL, NULL, FALSE);
    }
  }

  FreePool (Handles);
}

STATIC
VOID
AddGraphicsToConsole (
  VOID
  )
{
  EFI_STATUS                Status;
  EFI_HANDLE                *Handles;
  UINTN                     Count;
  UINTN                     Index;
  EFI_DEVICE_PATH_PROTOCOL  *Path;

  Status = gBS->LocateHandleBuffer (ByProtocol, &gEfiGraphicsOutputProtocolGuid, NULL, &Count, &Handles);
  if (EFI_ERROR (Status)) {
    return;
  }

  for (Index = 0; Index < Count; Index++) {
    Path = DevicePathFromHandle (Handles[Index]);
    if (Path == NULL) {
      continue;
    }

    EfiBootManagerUpdateConsoleVariable (ConOut, Path, NULL);
    EfiBootManagerUpdateConsoleVariable (ErrOut, Path, NULL);
  }

  FreePool (Handles);
}

STATIC
VOID
BootUsb (
  VOID
  )
{
  EFI_BOOT_MANAGER_LOAD_OPTION  *Options;
  UINTN                         Count;
  UINTN                         Index;

  EfiBootManagerRefreshAllBootOption ();
  Options = EfiBootManagerGetLoadOptions (&Count, LoadOptionTypeBoot);
  for (Index = 0; Index < Count; Index++) {
    if (IsUsbPath (Options[Index].FilePath)) {
      DEBUG ((DEBUG_INFO, "[SlimFallback] Booting %s\n", Options[Index].Description));
      EfiBootManagerBoot (&Options[Index]);
    }
  }

  EfiBootManagerFreeLoadOptions (Options, Count);
}

/**
  Run the UEFI shell from the firmware volume this application was loaded from.

  @retval EFI_SUCCESS  The shell ran and exited.
  @retval other        The shell could not be started.
**/
STATIC
EFI_STATUS
RunShell (
  VOID
  )
{
  EFI_STATUS                         Status;
  EFI_LOADED_IMAGE_PROTOCOL          *LoadedImage;
  MEDIA_FW_VOL_FILEPATH_DEVICE_PATH  FileNode;
  EFI_DEVICE_PATH_PROTOCOL           *Path;
  EFI_BOOT_MANAGER_LOAD_OPTION       Option;

  Status = gBS->HandleProtocol (gImageHandle, &gEfiLoadedImageProtocolGuid, (VOID **)&LoadedImage);
  if (EFI_ERROR (Status)) {
    return Status;
  }

  EfiInitializeFwVolDevicepathNode (&FileNode, &gUefiShellFileGuid);
  Path = AppendDevicePathNode (DevicePathFromHandle (LoadedImage->DeviceHandle), (EFI_DEVICE_PATH_PROTOCOL *)&FileNode);
  if (Path == NULL) {
    return EFI_OUT_OF_RESOURCES;
  }

  Status = EfiBootManagerInitializeLoadOption (
             &Option,
             LoadOptionNumberUnassigned,
             LoadOptionTypeBoot,
             LOAD_OPTION_ACTIVE,
             L"UEFI Shell",
             Path,
             NULL,
             0
             );
  FreePool (Path);
  if (EFI_ERROR (Status)) {
    return Status;
  }

  EfiBootManagerBoot (&Option);
  Status = Option.Status;
  EfiBootManagerFreeLoadOption (&Option);
  return Status;
}

EFI_STATUS
EFIAPI
SlimFallbackMain (
  IN EFI_HANDLE        ImageHandle,
  IN EFI_SYSTEM_TABLE  *SystemTable
  )
{
  EFI_STATUS  Status;

  ConnectUsbHosts ();
  AddGraphicsToConsole ();
  EfiBootManagerUpdateConsoleVariable (ConIn, (EFI_DEVICE_PATH_PROTOCOL *)&mUsbKeyboard, NULL);
  EfiBootManagerConnectAllDefaultConsoles ();
  EfiBootManagerConnectAll ();

  BootUsb ();

  Status = RunShell ();
  DEBUG ((DEBUG_ERROR, "[SlimFallback] UEFI shell: %r\n", Status));
  if (!EFI_ERROR (Status)) {
    gRT->ResetSystem (EfiResetCold, EFI_SUCCESS, 0, NULL);
  }

  return Status;
}
