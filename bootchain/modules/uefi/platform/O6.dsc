# @file
#
#  Copyright 2024-2025 Radxa Computer (Shenzhen) Co., Ltd. All Rights Reserved.
#  Copyright 2022 Cix Technology (Shanghai) Co., Ltd. All Rights Reserved.
#  Copyright (c) 2011 - 2020, ARM Limited. All rights reserved.
#  Copyright (c) 2017 - 2018, Andrei Warkentin <andrey.warkentin@gmail.com>
#  Copyright (c) 2015 - 2021, Intel Corporation. All rights reserved.
#  Copyright (c) 2014, Linaro Limited. All rights reserved.
#
#  SPDX-License-Identifier: BSD-2-Clause-Patent
#
##

################################################################################
#
# Defines Section - statements that will be processed to create a Makefile.
#
################################################################################
[Defines]
  PLATFORM_NAME                  = O6
  PLATFORM_GUID                  = 53cfca21-0399-4802-a3c0-e86437a42183
  PLATFORM_VERSION               = 1.0
  DSC_SPECIFICATION              = 0x0001001A
  OUTPUT_DIRECTORY               = $(PATH_BUILD_OUTPUT)  # ODP: Allow environment variable to set remnants folder
  SUPPORTED_ARCHITECTURES        = AARCH64
  BUILD_TARGETS                  = DEBUG|RELEASE|NOOPT
  SKUID_IDENTIFIER               = DEFAULT
  FLASH_DEFINITION               = platform/O6.fdf       # ODP: Use ODP flavor of the 06 DSC/FDF pair
  PCD_DYNAMIC_AS_DYNAMICEX       = TRUE
  BUILD_NUMBER                   = 0x00000004


  # ODP:  Normally all platform resources reside in the directory next to this DSC/FDF
  #       file pair, but for initial dev, we are reaching into the provided submodule


[Defines]
  #
#  Copyright 2024 Cix Technology Group Co., Ltd. All Rights Reserved
  #[Compile parameter]
  #
  # Compile paramters from command line -D FLAG=VALUE
  # Any add-on should start with COMPILE_ prefix in UEFI
  #

  #
  #[Function control]
  #
  # Control driver/library/pcd definition and instantiation
  #
  # I2C
  #
  #[Variable setup]
  #
  # Variable definition
  #
[Defines]

[Defines]

  # Cannot be lower than LOWEST_SUPPORTED_FIRMWARE_VERSION

################################################################################
#
# Define Macro section - list of all macro defined by this Platform.
# Override some marco define for platform requirement
#
################################################################################

##################################################
# Define override here for evb
##################################################
  # DEFINE SOC_GPIO_INTR_ENABLE       = TRUE



#
# Network definition
#

#ACPI Boot




# ODP: Platform specific setting for changing the debug output level

# ODP: Platform override for Sky1Common.dsc
# @file
#
#  Copyright 2024 Cix Technology Group Co., Ltd. All Rights Reserved.
#  Copyright (c) 2011 - 2020, ARM Limited. All rights reserved.
#  Copyright (c) 2017 - 2018, Andrei Warkentin <andrey.warkentin@gmail.com>
#  Copyright (c) 2015 - 2021, Intel Corporation. All rights reserved.
#  Copyright (c) 2014, Linaro Limited. All rights reserved.
#
#  SPDX-License-Identifier: BSD-2-Clause-Patent
#
##

################################################################################
#
# Defines Section - statements that will be processed to create a Makefile.
#
################################################################################
[Defines]

################################################################################
#
# Library Class section - list of all Library Classes needed by this Platform.
#
################################################################################

## @file
# Mde DSC include file for [LibraryClasses*] section of all Architectures.
#
# This file can be included to the [LibraryClasses*] section(s) of a platform DSC file
# by using "!include MdePkg/MdeLibs.dsc.inc" to specify the library instances
# of some EDKII basic/common library classes.
#
# Copyright (c) 2021 - 2022, Intel Corporation. All rights reserved.<BR>
#
#    SPDX-License-Identifier: BSD-2-Clause-Patent
#
##

[LibraryClasses]
  RegisterFilterLib|MdePkg/Library/RegisterFilterLibNull/RegisterFilterLibNull.inf
  CpuLib|MdePkg/Library/BaseCpuLib/BaseCpuLib.inf
  SmmCpuRendezvousLib|MdePkg/Library/SmmCpuRendezvousLibNull/SmmCpuRendezvousLibNull.inf
[LibraryClasses.common]
  DebugLib|Platform/CIX/Sky1/Library/BaseDebugLibSerialPort/BaseDebugLibSerialPort.inf
  PostCodeLib|Silicon/CIX/Sky1/Library/CixBasePostCodeLibMmio/BasePostCodeLibMmio.inf
  DebugPrintErrorLevelLib|MdePkg/Library/BaseDebugPrintErrorLevelLib/BaseDebugPrintErrorLevelLib.inf
  BaseLib|MdePkg/Library/BaseLib/BaseLib.inf
  SafeIntLib|MdePkg/Library/BaseSafeIntLib/BaseSafeIntLib.inf
  BmpSupportLib|MdeModulePkg/Library/BaseBmpSupportLib/BaseBmpSupportLib.inf
  SynchronizationLib|MdePkg/Library/BaseSynchronizationLib/BaseSynchronizationLib.inf
  PerformanceLib|MdePkg/Library/BasePerformanceLibNull/BasePerformanceLibNull.inf
  ReportStatusCodeLib|MdePkg/Library/BaseReportStatusCodeLibNull/BaseReportStatusCodeLibNull.inf
  PrintLib|MdePkg/Library/BasePrintLib/BasePrintLib.inf
  PeCoffGetEntryPointLib|MdePkg/Library/BasePeCoffGetEntryPointLib/BasePeCoffGetEntryPointLib.inf
  PeCoffLib|MdePkg/Library/BasePeCoffLib/BasePeCoffLib.inf
  IoLib|MdePkg/Library/BaseIoLibIntrinsic/BaseIoLibIntrinsic.inf
  UefiDecompressLib|MdePkg/Library/BaseUefiDecompressLib/BaseUefiDecompressLib.inf
  CpuLib|MdePkg/Library/BaseCpuLib/BaseCpuLib.inf
  UefiLib|MdePkg/Library/UefiLib/UefiLib.inf
  UefiUsbLib|MdePkg/Library/UefiUsbLib/UefiUsbLib.inf
  HobLib|MdePkg/Library/DxeHobLib/DxeHobLib.inf
  UefiRuntimeServicesTableLib|MdePkg/Library/UefiRuntimeServicesTableLib/UefiRuntimeServicesTableLib.inf
  DevicePathLib|MdePkg/Library/UefiDevicePathLib/UefiDevicePathLib.inf
  UefiBootServicesTableLib|MdePkg/Library/UefiBootServicesTableLib/UefiBootServicesTableLib.inf
  DxeServicesTableLib|MdePkg/Library/DxeServicesTableLib/DxeServicesTableLib.inf
  DxeServicesLib|MdePkg/Library/DxeServicesLib/DxeServicesLib.inf
  UefiDriverEntryPoint|MdePkg/Library/UefiDriverEntryPoint/UefiDriverEntryPoint.inf
  UefiApplicationEntryPoint|MdePkg/Library/UefiApplicationEntryPoint/UefiApplicationEntryPoint.inf
  HiiLib|MdeModulePkg/Library/UefiHiiLib/UefiHiiLib.inf
  UefiHiiServicesLib|MdeModulePkg/Library/UefiHiiServicesLib/UefiHiiServicesLib.inf
  SortLib|MdeModulePkg/Library/UefiSortLib/UefiSortLib.inf
  UefiRuntimeLib|MdePkg/Library/UefiRuntimeLib/UefiRuntimeLib.inf
  OrderedCollectionLib|MdePkg/Library/BaseOrderedCollectionRedBlackTreeLib/BaseOrderedCollectionRedBlackTreeLib.inf
  #
  # Ramdisk Requirements
  #
  FileExplorerLib|MdeModulePkg/Library/FileExplorerLib/FileExplorerLib.inf

  # Allow dynamic PCDs
  #
  PcdLib|MdePkg/Library/DxePcdLib/DxePcdLib.inf

  BaseMemoryLib|MdePkg/Library/BaseMemoryLib/BaseMemoryLib.inf

  #
  # It is not possible to prevent the ARM compiler from inserting calls to intrinsic functions.
  # This library provides the instrinsic functions such a compiler may generate calls to.
  #
  NULL|ArmPkg/Library/CompilerIntrinsicsLib/CompilerIntrinsicsLib.inf

  # Add support for GCC stack protector
  NULL|MdePkg/Library/BaseStackCheckLib/BaseStackCheckLib.inf

  # ARM Architectural Libraries
  CacheMaintenanceLib|ArmPkg/Library/ArmCacheMaintenanceLib/ArmCacheMaintenanceLib.inf
  DefaultExceptionHandlerLib|Silicon/CIX/Sky1/Library/DefaultExceptionHandlerLib/DefaultExceptionHandlerLib.inf
  CpuExceptionHandlerLib|ArmPkg/Library/ArmExceptionLib/ArmExceptionLib.inf
  ArmDisassemblerLib|ArmPkg/Library/ArmDisassemblerLib/ArmDisassemblerLib.inf
  ArmGicLib|ArmPkg/Drivers/ArmGic/ArmGicLib.inf
  ArmGicArchLib|ArmPkg/Library/ArmGicArchLib/ArmGicArchLib.inf
  DmaLib|EmbeddedPkg/Library/NonCoherentDmaLib/NonCoherentDmaLib.inf
  TimeBaseLib|EmbeddedPkg/Library/TimeBaseLib/TimeBaseLib.inf
  ArmPlatformStackLib|ArmPlatformPkg/Library/ArmPlatformStackLib/ArmPlatformStackLib.inf
  ArmSmcLib|ArmPkg/Library/ArmSmcLib/ArmSmcLib.inf
  ArmHvcLib|ArmPkg/Library/ArmHvcLib/ArmHvcLib.inf
  ArmGenericTimerCounterLib|ArmPkg/Library/ArmGenericTimerPhyCounterLib/ArmGenericTimerPhyCounterLib.inf

  UncachedMemoryAllocationLib|Silicon/CIX/Sky1/Library/UncachedMemoryAllocationLib/UncachedMemoryAllocationLib.inf

  # ARM PL011 UART Driver
  PL011UartClockLib|Silicon/CIX/Sky1/Library/PL011UartClockLib/PL011UartClockLib.inf
  PL011UartLib|ArmPlatformPkg/Library/PL011UartLib/PL011UartLib.inf
  SerialPortLib|Silicon/CIX/Sky1/Library/PL011SerialPortLib/PL011SerialPortLib.inf
  TimerLib|Silicon/CIX/Sky1/Library/ArmArchTimerLib/ArmArchTimerLib.inf

  #
  # Uncomment (and comment out the next line) For RealView Debugger. The Standard IO window
  # in the debugger will show load and unload commands for symbols. You can cut and paste this
  # into the command window to load symbols. We should be able to use a script to do this, but
  # the version of RVD I have does not support scripts accessing system memory.
  #
  #PeCoffExtraActionLib|ArmPkg/Library/RvdPeCoffExtraActionLib/RvdPeCoffExtraActionLib.inf
  PeCoffExtraActionLib|ArmPkg/Library/DebugPeCoffExtraActionLib/DebugPeCoffExtraActionLib.inf
  #PeCoffExtraActionLib|MdePkg/Library/BasePeCoffExtraActionLibNull/BasePeCoffExtraActionLibNull.inf

  DebugAgentLib|MdeModulePkg/Library/DebugAgentLibNull/DebugAgentLibNull.inf
  DebugAgentTimerLib|EmbeddedPkg/Library/DebugAgentTimerLibNull/DebugAgentTimerLibNull.inf

  # Flattened Device Tree (FDT) access library
  FdtLib|EmbeddedPkg/Library/FdtLib/FdtLib.inf

  PartitionLib|Platform/CIX/Sky1/Library/PartitionLib/PartitionLib.inf
  FlashUpdateLib|Platform/CIX/Sky1/Library/FlashUpdateLib/FlashUpdateLib.inf
  AvbLib|Platform/CIX/Sky1/Library/avb/AvbLib.inf
  BootLib|Platform/CIX/Sky1/Library/BootLib/BootLib.inf
  LaunchEfiLib|Platform/CIX/Sky1/Library/LaunchEfiLib/LaunchEfiLib.inf
  MiniFastbootLib|Platform/CIX/Sky1/Library/FastbootLib/MiniFastbootLib.inf
  OpteeLib|Platform/CIX/Sky1/Library/OpteeLib/OpteeLib.inf
  EfusePublicKeyLib|Platform/CIX/Sky1/Library/EfusePublicKeyLib/EfusePublicKeyLib.inf
  FctMiscLib|Platform/CIX/Sky1/Library/FctMiscLib/FctMiscLib.inf
  StmmInfoLib|Platform/CIX/Sky1/Library/StmmInfoLib/StmmInfoLib.inf

  #
  # Secure Boot dependencies
  #
  TpmMeasurementLib|SecurityPkg/Library/DxeTpmMeasurementLib/DxeTpmMeasurementLib.inf
  AuthVariableLib|SecurityPkg/Library/AuthVariableLib/AuthVariableLib.inf
  SecureBootVariableLib|SecurityPkg/Library/SecureBootVariableLib/SecureBootVariableLib.inf
  SecureBootVariableProvisionLib|SecurityPkg/Library/SecureBootVariableProvisionLib/SecureBootVariableProvisionLib.inf

  # re-use the UserPhysicalPresent() dummy implementation from the ovmf tree
  PlatformSecureLib|OvmfPkg/Library/PlatformSecureLib/PlatformSecureLib.inf

  BaseCryptLib|CryptoPkg/Library/BaseCryptLib/BaseCryptLib.inf
  IntrinsicLib|CryptoPkg/Library/IntrinsicLib/IntrinsicLib.inf
  OpensslLib|CryptoPkg/Library/OpensslLib/OpensslLib.inf
  TlsLib|CryptoPkg/Library/TlsLib/TlsLib.inf
  PlatformPKProtectionLib|SecurityPkg/Library/PlatformPKProtectionLibVarPolicy/PlatformPKProtectionLibVarPolicy.inf
  # RngLib|MdePkg/Library/DxeRngLib/DxeRngLib.inf
  RngLib|MdePkg/Library/BaseRngLibTimerLib/BaseRngLibTimerLib.inf
  VarCheckLib|MdeModulePkg/Library/VarCheckLib/VarCheckLib.inf
  VariableFlashInfoLib|MdeModulePkg/Library/BaseVariableFlashInfoLib/BaseVariableFlashInfoLib.inf
  VariablePolicyLib|MdeModulePkg/Library/VariablePolicyLib/VariablePolicyLib.inf
  VariablePolicyHelperLib|MdeModulePkg/Library/VariablePolicyHelperLib/VariablePolicyHelperLib.inf

  CustomizedDisplayLib|MdeModulePkg/Library/CustomizedDisplayLib/CustomizedDisplayLib.inf
  ConfigParamsDataBlockLib|Silicon/CIX/Sky1/Library/ConfigParamsDataBlockLib/ConfigParamsDataBlockLib.inf
  PlatformConfigParamsDataBlockLib|Platform/CIX/Sky1/Library/PlatformConfigParamsDataBlockLib/PlatformConfigParamsDataBlockLib.inf
  PinMuxLib|Silicon/CIX/Sky1/Library/PinMuxLib/PinMuxLib.inf
  PinMuxTableLib|Silicon/CIX/Sky1/Library/PinMuxTableNullLib/PinMuxTableNullLib.inf
  GpioLib|Silicon/CIX/Sky1/Library/GpioLib/GpioLib.inf
  GpioTableLib|Silicon/CIX/Sky1/Library/GpioTableNullLib/GpioTableNullLib.inf
  FchDmaLib|Silicon/CIX/Sky1/Library/FchDmaLib/FchDmaLib.inf
  FchTimerLib|Silicon/CIX/Sky1/Library/FchTimerLib/FchTimerLib.inf
  OpnLib|Silicon/CIX/Sky1/Library/OpnLib/OpnLib.inf
  SpiLib|Silicon/CIX/Sky1/Library/SpiLib/SpiLib.inf
  I2cLib|Silicon/CIX/Sky1/Library/I2cLib/I2cLib.inf
  EcLib|Platform/CIX/Sky1/Library/Ite5570EcLib/Ite5570EcLib.inf
  ConfigParamsHookLib|Silicon/CIX/Sky1/Library/ConfigParamsHookNullLib/ConfigParamsHookNullLib.inf
  PlatformConfigParamsHookLib|Platform/CIX/Sky1/Library/PlatformConfigParamsHookNullLib/PlatformConfigParamsHookNullLib.inf
  PlatformEnvHookLib|Platform/CIX/Sky1/Library/PlatformEnvHookNullLib/PlatformEnvHookNullLib.inf
  PlatformBootHookLib|Platform/CIX/Sky1/Library/PlatformBootHookNullLib/PlatformBootHookNullLib.inf
  NorFlashLib|Silicon/CIX/Sky1/Library/NorFlashLib/NorFlashStmmRuntimeLib.inf
  NorFlashBasicLib|Silicon/CIX/Sky1/Library/NorFlashBasicLib/NorFlashBasicStmmLib.inf
  PciHostBridgeLib|Silicon/CIX/Sky1/Library/PciHostBridgeLib/PciHostBridgeLib.inf
  PciSegmentLib|Silicon/CIX/Sky1/Library/PciSegmentLib/PciSegmentLib.inf
  PlatformPcieLib|Silicon/CIX/Sky1/Library/PlatformPcieLib/PlatformPcieLib.inf
  NetLib|NetworkPkg/Library/DxeNetLib/DxeNetLib.inf

  DpuDxe|Silicon/CIX/Sky1/Drivers/DpuDxe/DpuDxe.inf
  DisplayLib|Silicon/CIX/Sky1/Library/DisplayLib/DisplayLib.inf

  ArmMtlLib|Silicon/CIX/Sky1/Library/CixMtlLib/CixMtlLib.inf
  DtbUpdateLib|Platform/CIX/Sky1/Library/DtbUpdateLib/DtbUpdateLib.inf
  DtbCommonLib|Platform/CIX/Sky1/Library/DtbCommonLib/DtbCommonLib.inf
  ArmLib|ArmPkg/Library/ArmLib/ArmBaseLib.inf
  ArmMmuLib|ArmPkg/Library/ArmMmuLib/ArmMmuBaseLib.inf
  # ODP: Change from using CIX library to ODP library to set the proper HOBs for Patina
  ArmPlatformLib|platform/Library/PlatformLib/PlatformLib.inf # ArmPlatformLib|Platform/CIX/Sky1/Library/PlatformLib/PlatformLib.inf
  CapsuleLib|MdeModulePkg/Library/DxeCapsuleLibNull/DxeCapsuleLibNull.inf
  UefiBootManagerLib|MdeModulePkg/Library/UefiBootManagerLib/UefiBootManagerLib.inf
  BootLogoLib|MdeModulePkg/Library/BootLogoLib/BootLogoLib.inf
  PlatformBootManagerLib|Platform/CIX/Sky1/Library/PlatformBootManagerLib/PlatformBootManagerLib.inf
  FileExplorerLib|MdeModulePkg/Library/FileExplorerLib/FileExplorerLib.inf
  AcpiLib|EmbeddedPkg/Library/AcpiLib/AcpiLib.inf
  SocInitLib|Silicon/CIX/Sky1/Library/SocInitLib/SocInitLib.inf
  FirmwareParseLib|Silicon/CIX/Sky1/Library/FirmwareParseLib/FirmwareParseLib.inf
  HwMutexLib|Silicon/CIX/Sky1/Library/HwMutexLib/HwMutexLib.inf
  OpensslLib|CryptoPkg/Library/OpensslLib/OpensslLib.inf
  IntrinsicLib|CryptoPkg/Library/IntrinsicLib/IntrinsicLib.inf
  BaseCryptLib|CryptoPkg/Library/BaseCryptLib/BaseCryptLib.inf
  #CapsuleLib|MdeModulePkg/Library/DxeCapsuleLibFmp/DxeCapsuleLib.inf
  CapsuleLib|MdeModulePkg/Library/DxeCapsuleLibNull/DxeCapsuleLibNull.inf
  EdkiiSystemCapsuleLib|Platform/CIX/Sky1/Library/EdkiiSystemCapsuleLib/EdkiiSystemCapsuleLib.inf
  FmpAuthenticationLib|SecurityPkg/Library/FmpAuthenticationLibPkcs7/FmpAuthenticationLibPkcs7.inf
  IniParsingLib|SignedCapsulePkg/Library/IniParsingLib/IniParsingLib.inf
  PlatformFlashAccessLib|SignedCapsulePkg/Library/PlatformFlashAccessLibNull/PlatformFlashAccessLibNull.inf
#  PlatformFlashAccessLib|Platform/RaspberryPi/Library/PlatformFlashAccessLib/PlatformFlashAccessLib.inf
  DisplayUpdateProgressLib|MdeModulePkg/Library/DisplayUpdateProgressLibGraphics/DisplayUpdateProgressLibGraphics.inf

  RebootReasonLib|Silicon/CIX/Sky1/Library/RebootReasonLib/RebootReasonLib.inf

  CsuPmIpcLib|Silicon/CIX/Sky1/Library/CsuPmIpcLib/CsuPmIpcLib.inf

  ShMemLib|Silicon/CIX/Sky1/Library/ShMemLib/ShMemLib.inf
  MailBoxLib|Silicon/CIX/Sky1/Library/MailBoxLib/MailBoxLib.inf

  RealTimeClockLib|EmbeddedPkg/Library/VirtualRealTimeClockLib/VirtualRealTimeClockLib.inf
  AcpiHelperLib|DynamicTablesPkg/Library/Common/AcpiHelperLib/AcpiHelperLib.inf
  AmlLib|Platform/CIX/Sky1/Library/Acpi/CIX/AmlLib/AmlLib.inf
  TableHelperLib|DynamicTablesPkg/Library/Common/TableHelperLib/TableHelperLib.inf
  CixSipLib|Silicon/CIX/Sky1/Library/CixSipLib/CixSipLib.inf

  UsbLib|Silicon/CIX/Sky1/Library/UsbLib/UsbLib.inf
  CpuInfoLib|Silicon/CIX/Sky1/Library/CpuInfoLib/CpuInfoLib.inf
  HwHarvestLib|Silicon/CIX/Sky1/Library/HwHarvestLib/HwHarvestLib.inf
  #CommonLib|Platform/CIX/Sky1/Library/CommonLib/CommonLib.inf
  CixS3IoLib|Platform/CIX/Sky1/Library/CixS3IoLib/CixS3IoLib.inf
  ArmScmiLib|Silicon/CIX/Sky1/Library/ArmScmiLib/ArmScmiLib.inf
  OemMiscLib|Platform/CIX/Sky1/Library/SmbiosMiscLib/SmbiosMiscLib.inf
  CixFwBootPerfLib|Platform/CIX/Sky1/Library/CixFwBootPerfLib/CixFwBootPerfLib.inf
  EfiResetSystemLib|ArmPkg/Library/ArmPsciResetSystemLib/ArmPsciResetSystemLib.inf

  OpensslLib|CryptoPkg/Library/OpensslLib/OpensslLib.inf
  IntrinsicLib|CryptoPkg/Library/IntrinsicLib/IntrinsicLib.inf
  BaseCryptLib|CryptoPkg/Library/BaseCryptLib/BaseCryptLib.inf
  Tpm2CommandLib|SecurityPkg/Library/Tpm2CommandLib/Tpm2CommandLib.inf
  #Tcg2PhysicalPresenceLib|SecurityPkg/Library/DxeTcg2PhysicalPresenceLib/DxeTcg2PhysicalPresenceLib.inf
  Tcg2PhysicalPresenceLib|Platform/CIX/Sky1/Library/DxeTcg2PhysicalPresenceLib/DxeTcg2PhysicalPresenceLib.inf
  Tcg2PpVendorLib|SecurityPkg/Library/Tcg2PpVendorLibNull/Tcg2PpVendorLibNull.inf
  TpmMeasurementLib|SecurityPkg/Library/DxeTpmMeasurementLib/DxeTpmMeasurementLib.inf
  TpmPlatformHierarchyLib|SecurityPkg/Library/PeiDxeTpmPlatformHierarchyLib/PeiDxeTpmPlatformHierarchyLib.inf
  Tpm2DeviceLib|Platform/CIX/Sky1/Library/Tpm2DeviceLib/Tpm2DeviceLib.inf
    DTpmDeviceLib|Platform/CIX/Sky1/Library/DTpmDeviceLib/DTpmDeviceLib.inf
    FTpmDeviceLib|Platform/CIX/Sky1/Library/FTpmDeviceLibNull/FTpmDeviceLibNull.inf

  # Library for Vendor Guid Variable Sync From Flash
  CixGPNVLib|Platform/CIX/Sky1/Library/CixGPNVLib/CixGPNVLib.inf

[LibraryClasses.common.SEC]
  PcdLib|MdePkg/Library/BasePcdLibNull/BasePcdLibNull.inf
  BaseMemoryLib|MdePkg/Library/BaseMemoryLib/BaseMemoryLib.inf
  MemoryInitPeiLib|Platform/CIX/Sky1/Library/MemoryInitPeiLib/MemoryInitPeiLib.inf
  PlatformPeiLib|ArmPlatformPkg/PlatformPei/PlatformPeiLib.inf
  ExtractGuidedSectionLib|EmbeddedPkg/Library/PrePiExtractGuidedSectionLib/PrePiExtractGuidedSectionLib.inf
  LzmaDecompressLib|MdeModulePkg/Library/LzmaCustomDecompressLib/LzmaCustomDecompressLib.inf
  PrePiLib|EmbeddedPkg/Library/PrePiLib/PrePiLib.inf
  HobLib|EmbeddedPkg/Library/PrePiHobLib/PrePiHobLib.inf
  PrePiHobListPointerLib|ArmPlatformPkg/Library/PrePiHobListPointerLib/PrePiHobListPointerLib.inf
  MemoryAllocationLib|EmbeddedPkg/Library/PrePiMemoryAllocationLib/PrePiMemoryAllocationLib.inf

[LibraryClasses.common.DXE_CORE]
  HobLib|MdePkg/Library/DxeCoreHobLib/DxeCoreHobLib.inf
  MemoryAllocationLib|MdeModulePkg/Library/DxeCoreMemoryAllocationLib/DxeCoreMemoryAllocationLib.inf
  DxeCoreEntryPoint|MdePkg/Library/DxeCoreEntryPoint/DxeCoreEntryPoint.inf
  ExtractGuidedSectionLib|MdePkg/Library/DxeExtractGuidedSectionLib/DxeExtractGuidedSectionLib.inf
  PerformanceLib|MdeModulePkg/Library/DxeCorePerformanceLib/DxeCorePerformanceLib.inf

[LibraryClasses.common.DXE_DRIVER]
  SecurityManagementLib|MdeModulePkg/Library/DxeSecurityManagementLib/DxeSecurityManagementLib.inf
  PerformanceLib|MdeModulePkg/Library/DxePerformanceLib/DxePerformanceLib.inf
  MemoryAllocationLib|MdePkg/Library/UefiMemoryAllocationLib/UefiMemoryAllocationLib.inf
  FileHandleLib|MdePkg/Library/UefiFileHandleLib/UefiFileHandleLib.inf
  NonDiscoverableDeviceRegistrationLib|MdeModulePkg/Library/NonDiscoverableDeviceRegistrationLib/NonDiscoverableDeviceRegistrationLib.inf

[LibraryClasses.common.UEFI_APPLICATION]
  PerformanceLib|MdeModulePkg/Library/DxePerformanceLib/DxePerformanceLib.inf
  MemoryAllocationLib|MdePkg/Library/UefiMemoryAllocationLib/UefiMemoryAllocationLib.inf
  HiiLib|MdeModulePkg/Library/UefiHiiLib/UefiHiiLib.inf
  ShellLib|ShellPkg/Library/UefiShellLib/UefiShellLib.inf
  FileHandleLib|MdePkg/Library/UefiFileHandleLib/UefiFileHandleLib.inf
  AblAuthenticateLib|Platform/CIX/Sky1/Library/AblAuthenticateLib/AblAuthenticateLib.inf

[LibraryClasses.common.UEFI_DRIVER]
  ExtractGuidedSectionLib|MdePkg/Library/DxeExtractGuidedSectionLib/DxeExtractGuidedSectionLib.inf
  PerformanceLib|MdeModulePkg/Library/DxePerformanceLib/DxePerformanceLib.inf
  MemoryAllocationLib|MdePkg/Library/UefiMemoryAllocationLib/UefiMemoryAllocationLib.inf
  UefiScsiLib|MdePkg/Library/UefiScsiLib/UefiScsiLib.inf
  BaseHidParseReportLib|Platform/CIX/Sky1/Library/BaseHidParseReportLib/BaseHidParseReportLib.inf

[LibraryClasses.common.DXE_RUNTIME_DRIVER]
  # Runtime debug messages may crash an OS unless serial output to MMIO mapped UARTs is inhibited
  DebugLib|MdePkg/Library/DxeRuntimeDebugLibSerialPort/DxeRuntimeDebugLibSerialPort.inf
  MemoryAllocationLib|MdePkg/Library/UefiMemoryAllocationLib/UefiMemoryAllocationLib.inf
  CapsuleLib|MdeModulePkg/Library/DxeCapsuleLibNull/DxeCapsuleLibNull.inf
  EfiResetSystemLib|ArmPkg/Library/ArmPsciResetSystemLib/ArmPsciResetSystemLib.inf
  ArmSmcLib|ArmPkg/Library/ArmSmcLib/ArmSmcLib.inf
  HwMutexLib|Silicon/CIX/Sky1/Library/HwMutexLib/HwMutexRuntimeLib.inf
  PinMuxLib|Silicon/CIX/Sky1/Library/PinMuxLib/PinMuxRuntimeLib.inf
  GpioLib|Silicon/CIX/Sky1/Library/GpioLib/GpioRuntimeLib.inf
  VariablePolicyLib|MdeModulePkg/Library/VariablePolicyLib/VariablePolicyLibRuntimeDxe.inf

  BaseCryptLib|CryptoPkg/Library/BaseCryptLib/RuntimeCryptLib.inf
  CapsuleLib|MdeModulePkg/Library/DxeCapsuleLibFmp/DxeRuntimeCapsuleLib.inf

###################################################################################################
# BuildOptions Section - Define the module specific tool chain flags that should be used as
#                        the default flags for a module. These flags are appended to any
#                        standard flags that are defined by the build process.
###################################################################################################

[BuildOptions]
  GCC:*_*_*_CC_FLAGS          = -fno-common

[BuildOptions.common.EDKII.DXE_RUNTIME_DRIVER]
  GCC:*_*_AARCH64_DLINK_FLAGS = -z common-page-size=0x10000

################################################################################
#
# Pcd Section - list of all EDK II PCD Entries defined by this Platform
#
################################################################################

[PcdsFeatureFlag.common]

  gEmbeddedTokenSpaceGuid.PcdPrePiProduceMemoryTypeInformationHob|TRUE
  gEfiMdeModulePkgTokenSpaceGuid.PcdTurnOffUsbLegacySupport|TRUE
  gEfiMdeModulePkgTokenSpaceGuid.PcdConOutGopSupport|TRUE
  gEfiMdeModulePkgTokenSpaceGuid.PcdInstallAcpiSdtProtocol|TRUE
  gEfiMdeModulePkgTokenSpaceGuid.PcdEnableVariableRuntimeCache|FALSE

[PcdsDynamicExDefault.common.DEFAULT]
  gEfiSignedCapsulePkgTokenSpaceGuid.PcdEdkiiSystemFirmwareImageDescriptor|{0x0}|VOID*|0x100
  gEfiMdeModulePkgTokenSpaceGuid.PcdSystemFmpCapsuleImageTypeIdGuid|{0x08, 0x98, 0x1c, 0x35, 0x53, 0x4b, 0x63, 0x43, 0x93, 0x14, 0xd3, 0x39, 0x38, 0x6e, 0x56, 0x85}
  gEfiSignedCapsulePkgTokenSpaceGuid.PcdEdkiiSystemFirmwareFileGuid|{0xcf, 0x4f, 0x2e, 0x64, 0xf7, 0x2d, 0x15, 0x44, 0x8b, 0x70, 0xa0, 0x39, 0x09, 0xc5, 0x7b, 0x55}
[PcdsFixedAtBuild.common]
  gEfiMdePkgTokenSpaceGuid.PcdMaximumUnicodeStringLength|1000000
  gEfiMdePkgTokenSpaceGuid.PcdMaximumAsciiStringLength|1000000
  gEfiMdePkgTokenSpaceGuid.PcdMaximumLinkedListLength|1000000
  gEfiMdePkgTokenSpaceGuid.PcdSpinLockTimeout|10000000
  gEfiMdePkgTokenSpaceGuid.PcdDebugClearMemoryValue|0xAF
  gEfiMdePkgTokenSpaceGuid.PcdPerformanceLibraryPropertyMask|0
  gEfiMdePkgTokenSpaceGuid.PcdPostCodePropertyMask|0x08
  gEfiMdePkgTokenSpaceGuid.PcdUefiLibMaxPrintBufferSize|320
  # DEBUG_ASSERT_ENABLED       0x01
  # DEBUG_PRINT_ENABLED        0x02
  # DEBUG_CODE_ENABLED         0x04
  # CLEAR_MEMORY_ENABLED       0x08
  # ASSERT_BREAKPOINT_ENABLED  0x10
  # ASSERT_DEADLOOP_ENABLED    0x20
  gEfiMdePkgTokenSpaceGuid.PcdDebugPrintErrorLevel|0x800000CF

  gEfiMdePkgTokenSpaceGuid.PcdReportStatusCodePropertyMask|0x07

  gEmbeddedTokenSpaceGuid.PcdMemoryTypeEfiACPIReclaimMemory|0
  gEmbeddedTokenSpaceGuid.PcdMemoryTypeEfiACPIMemoryNVS|0
  gEmbeddedTokenSpaceGuid.PcdMemoryTypeEfiReservedMemoryType|0
  gEmbeddedTokenSpaceGuid.PcdMemoryTypeEfiRuntimeServicesData|0x450
  gEmbeddedTokenSpaceGuid.PcdMemoryTypeEfiRuntimeServicesCode|1200
  gEmbeddedTokenSpaceGuid.PcdMemoryTypeEfiBootServicesCode|1500
  gEmbeddedTokenSpaceGuid.PcdMemoryTypeEfiBootServicesData|13000
  gEmbeddedTokenSpaceGuid.PcdMemoryTypeEfiLoaderCode|0x1000
  gEmbeddedTokenSpaceGuid.PcdMemoryTypeEfiLoaderData|0
  gEmbeddedTokenSpaceGuid.PcdDmaDeviceOffset|0x00000000
  gEfiMdeModulePkgTokenSpaceGuid.PcdFirmwareVersionString|L"cix_sky1_alpha_0.6"
  gEfiMdePkgTokenSpaceGuid.PcdUefiVariableDefaultPlatformLangCodes|"en-US"
  gEfiMdeModulePkgTokenSpaceGuid.PcdFirmwareRevision|0x00000003

[PcdsFixedAtBuild.common]
  gArmPlatformTokenSpaceGuid.PcdClusterCount|1
  gArmPlatformTokenSpaceGuid.PcdCoreCount|12

  # The Primary Core is 0.0.4.0
  gArmTokenSpaceGuid.PcdArmPrimaryCore|0x400  #core4

  gArmPlatformTokenSpaceGuid.PcdCPUCorePrimaryStackSize|0x40000
  gArmTokenSpaceGuid.PcdSystemProductName|L"Sky1"
  # Runtime Variable storage
  gEfiMdeModulePkgTokenSpaceGuid.PcdEmuVariableNvStoreReserved|0
  gEfiMdeModulePkgTokenSpaceGuid.PcdEmuVariableNvModeEnable|FALSE
  gEfiMdeModulePkgTokenSpaceGuid.PcdMaxVariableSize|0x2000
  gEfiMdeModulePkgTokenSpaceGuid.PcdMaxAuthVariableSize|0x2800

  # Size of the region used by UEFI in permanent memory (Reserved 64MB)
  gArmPlatformTokenSpaceGuid.PcdSystemMemoryUefiRegionSize|0x08000000
  #
  # 0x82500000 - 0x01F00000  Reserved share memory
  # 0x84400000 - 0x00400000  FD (PcdFdBaseAddress, PcdFdSize)
  # 0x84800000 - 0x00800000  GOP Frame buffer
  # 0x85000000               normal memory
  # 0xA0000000 - 0x08000000  load boot.img (Grub+ OS Image + DTB + rootfs images) to 4G SRAM offset 0x2000_0000, which is 0xA000_0000 for AP CPU
  #
  #
  # This matches PcdFvBaseAddress, since everything less is the FD, and
  # will be reserved away.
  #

  gArmTokenSpaceGuid.PcdSystemMemoryBase|0x80000000
  gArmTokenSpaceGuid.PcdSystemMemorySize|0x100000000
  gCixPlatformTokenSpaceGuid.PcdKernelBootImgBase|0xA0000000
  gCixPlatformTokenSpaceGuid.PcdKernelBootImgSize|0x08000000
  gCixPlatformTokenSpaceGuid.PcdReservedSecureMemoryBase|0x80000000
  gCixPlatformTokenSpaceGuid.PcdReservedSecureMemorySize|0x02500000
  gCixPlatformTokenSpaceGuid.PcdReservedShareMemoryBase|0x82500000
  gCixPlatformTokenSpaceGuid.PcdReservedShareMemorySize|0x01F00000
  gArmPlatformTokenSpaceGuid.PcdArmLcdDdrFrameBufferBase|0x84800000
  gArmPlatformTokenSpaceGuid.PcdArmLcdDdrFrameBufferSize|0x00800000
  gCixPlatformTokenSpaceGuid.PcdReservedLinuxBase|0x86000000
  gCixPlatformTokenSpaceGuid.PcdReservedLinuxSize|0x06200000
  gCixPlatformTokenSpaceGuid.PcdReservedAndroidBase|0x140000000
  gCixPlatformTokenSpaceGuid.PcdReservedAndroidSize|0x120000000
  #
  # ARM General Interrupt Controller
  #
  gArmTokenSpaceGuid.PcdGicDistributorBase|0x0e010000    #0x0e001000
  gArmTokenSpaceGuid.PcdGicRedistributorsBase|0x0e090000 #0x0e081000
  ## SBSA Watchdog Count
  gArmPlatformTokenSpaceGuid.PcdWatchdogCount|1
  gArmTokenSpaceGuid.PcdGenericWatchdogControlBase|0x16003000
  gArmTokenSpaceGuid.PcdGenericWatchdogRefreshBase|0x16008000
  gArmTokenSpaceGuid.PcdGenericWatchdogEl2IntrNum|408
  # PL011 - Serial Terminal

  gEfiMdeModulePkgTokenSpaceGuid.PcdSerialRegisterBase|0x040D0000 #0x091e1000 #0x0a051000

  ## PL011 - EMS UART Terminal
  gArmPlatformTokenSpaceGuid.PcdSerialDbgRegisterBase|0x040e0000
  gArmPlatformTokenSpaceGuid.PcdSerialDbgInterrupt|331
  gArmPlatformTokenSpaceGuid.PcdSerialDbgUartBaudRate|115200
  # uart
  gEfiMdePkgTokenSpaceGuid.PcdUartDefaultBaudRate|115200 #115200 921600
  gArmPlatformTokenSpaceGuid.PL011UartClkInHz|100000000 #100Mhz 100000000 #25Mhz 25000000
  # timer
  gArmTokenSpaceGuid.PcdArmArchTimerFreqInHz|1000000000 #1Ghz 1000000000 #1Mhz 1000000
  gEfiMdePkgTokenSpaceGuid.PcdUartDefaultReceiveFifoDepth|0
  gArmPlatformTokenSpaceGuid.PL011UartInterrupt|330

  # We enlarge  PcdDiskIoDataBufferBlockNum to 1024 to align with write buffer size in Fastboot
  gEfiMdeModulePkgTokenSpaceGuid.PcdDiskIoDataBufferBlockNum|1024

  #
  # ACPI
  #
  gEfiMdeModulePkgTokenSpaceGuid.PcdAcpiExposedTableVersions|0x20
  gEmbeddedTokenSpaceGuid.PcdMemoryTypeEfiACPIReclaimMemory|0
  gEmbeddedTokenSpaceGuid.PcdMemoryTypeEfiACPIMemoryNVS|0

  # Clearing BIT0 in this PCD prevents installing a 32-bit SMBIOS entry point,
  # if the entry point version is >= 3.0. AARCH64 OSes cannot assume the
  # presence of the 32-bit entry point anyway (because many AARCH64 systems
  # don't have 32-bit addressable physical RAM), and the additional allocations
  # below 4 GB needlessly fragment the memory map. So expose the 64-bit entry
  # point only, for entry point versions >= 3.0.
  gEfiMdeModulePkgTokenSpaceGuid.PcdSmbiosVersion|0x0306
  gEfiMdeModulePkgTokenSpaceGuid.PcdSmbiosEntryPointProvideMethod|0x2

  gArmTokenSpaceGuid.PcdProcessorManufacturer|L"Cix Technology Group Co., Ltd."
  gArmTokenSpaceGuid.PcdProcessorAssetTag|L" "
  gArmTokenSpaceGuid.PcdProcessorPartNumber|L" "
  gCixTokenSpaceGuid.PcdCixProcessorVersion|L"CIX P1 CD8180"
  #
  #
  #
  # Fixed CPU settings.
  #

  ## Default Terminal Type
  ## 0-PCANSI, 1-VT100, 2-VT00+, 3-UTF8, 4-TTYTERM
  gEfiMdePkgTokenSpaceGuid.PcdDefaultTerminalType|4

  gEfiMdeModulePkgTokenSpaceGuid.PcdResetOnMemoryTypeInformationChange|FALSE
  gEfiMdeModulePkgTokenSpaceGuid.PcdBootManagerMenuFile|{ 0x21, 0xaa, 0x2c, 0x46, 0x14, 0x76, 0x03, 0x45, 0x83, 0x6e, 0x8a, 0xb6, 0xf4, 0x66, 0x23, 0x31 }

  gCixTokenSpaceGuid.PcdNorFlashNvramAddr|0x00380000
  gCixTokenSpaceGuid.PcdNorFlashNvramSize|0x28000


  gEmbeddedTokenSpaceGuid.PcdPrePiCpuIoSize|44

  gCixTokenSpaceGuid.PcdSystemTableSelect|0x00

[PcdsPatchableInModule]
  gEfiMdeModulePkgTokenSpaceGuid.PcdSerialClockRate|500000000
!if $(TARGET) == RELEASE
  gEfiMdePkgTokenSpaceGuid.PcdDebugPropertyMask|0x21
!else
  gEfiMdePkgTokenSpaceGuid.PcdDebugPropertyMask|0x2f
!endif
[PcdsDynamicHii.common.DEFAULT]
  #
  # Reset-related.
  #


  #
  # Common UEFI ones.
  #
  gEfiMdePkgTokenSpaceGuid.PcdPlatformBootTimeOut|L"Timeout"|gEfiGlobalVariableGuid|0x0|5
  gEfiMdeModulePkgTokenSpaceGuid.PcdBootDiscoveryPolicy|L"BootDiscoveryPolicy"|gBootDiscoveryPolicyMgrFormsetGuid|0

[PcdsDynamicDefault.common]
  #
  # Set video resolution for boot options and for text setup.
  #
  gEfiMdeModulePkgTokenSpaceGuid.PcdVideoHorizontalResolution|1920
  gEfiMdeModulePkgTokenSpaceGuid.PcdVideoVerticalResolution|1080
  gEfiMdeModulePkgTokenSpaceGuid.PcdSetupVideoHorizontalResolution|640
  gEfiMdeModulePkgTokenSpaceGuid.PcdSetupVideoVerticalResolution|480

  gEfiMdeModulePkgTokenSpaceGuid.PcdFlashNvStorageVariableSize|0x28000
  gEfiMdeModulePkgTokenSpaceGuid.PcdFlashNvStorageFtwWorkingSize|0x28000
  gEfiMdeModulePkgTokenSpaceGuid.PcdFlashNvStorageFtwSpareSize|0x28000

  gEfiMdeModulePkgTokenSpaceGuid.PcdFlashNvStorageVariableBase64|0x00380000
  gEfiMdeModulePkgTokenSpaceGuid.PcdFlashNvStorageFtwWorkingBase64|(0x00380000 + 0x28000)
  gEfiMdeModulePkgTokenSpaceGuid.PcdFlashNvStorageFtwSpareBase64|(0x00380000 + 0x28000 + 0x28000)
  gEmbeddedTokenSpaceGuid.PcdDmaDeviceLimit|0x17fffffff
################################################################################
#
# Components Section - list of all EDK II Modules needed by this Platform
#
################################################################################
[Components.common]
  #
  # PEI Phase modules
  #
  ArmPlatformPkg/PrePi/PeiUniCore.inf{
    <LibraryClasses>
      #DebugLib|MdePkg/Library/BaseDebugLibNull/BaseDebugLibNull.inf
  }

  #
  # DXE
  #
  MdeModulePkg/Core/Dxe/DxeMain.inf {
    <LibraryClasses>
      NULL|MdeModulePkg/Library/DxeCrc32GuidedSectionExtractLib/DxeCrc32GuidedSectionExtractLib.inf
  }
  MdeModulePkg/Universal/PCD/Dxe/Pcd.inf {
    <LibraryClasses>
      PcdLib|MdePkg/Library/BasePcdLibNull/BasePcdLibNull.inf
  }

  #
  # Architectural Protocols
  #
  # ODP: Patina provides CpuDxe support
  # ArmPkg/Drivers/CpuDxe/CpuDxe.inf
  MdeModulePkg/Core/RuntimeDxe/RuntimeDxe.inf
  Platform/CIX/Sky1/Drivers/PlatformConfigParamsManageDxe/PlatformConfigParamsManageDxe.inf
  Silicon/CIX/Sky1/Drivers/ConfigParamsManageDxe/ConfigParamsManageDxe.inf
  Silicon/CIX/Sky1/Drivers/SocDxe/SocDxe.inf
  Platform/CIX/Sky1/Drivers/PlatformDxe/PlatformDxe.inf
  # Platform/CIX/Sky1/Drivers/SampleCodeDxe/SampleCodeDxe.inf
  Platform/CIX/Sky1/Drivers/MmCommunicationDxe/ArmMmCommunication.inf {
    <LibraryClasses>
      NULL|StandaloneMmPkg/Library/VariableMmDependency/VariableMmDependency.inf
  }
  # ODP: NorFlashStmmRuntimeDxe was marking a region as useable when it was already useable
  #      Patina found this and flagged it as an error.
  platform/OVERRIDE/Silicon/CIX/Sky1/Drivers/NorFlashStmmRuntimeDxe/NorFlashStmmRuntimeDxe.inf
  MdeModulePkg/Universal/Variable/RuntimeDxe/VariableSmmRuntimeDxe.inf {
    <LibraryClasses>
      MmUnblockMemoryLib|MdePkg/Library/MmUnblockMemoryLib/MmUnblockMemoryLibNull.inf
  }
  Silicon/CIX/Sky1/Drivers/PcieInitDxe/PcieInitDxe.inf
  MdeModulePkg/Universal/SecurityStubDxe/SecurityStubDxe.inf {
    <LibraryClasses>
      NULL|SecurityPkg/Library/DxeImageVerificationLib/DxeImageVerificationLib.inf
  }
  SecurityPkg/VariableAuthenticated/SecureBootConfigDxe/SecureBootConfigDxe.inf
  SecurityPkg/EnrollFromDefaultKeysApp/EnrollFromDefaultKeysApp.inf
  Platform/CIX/Sky1/Drivers/SecureBootDxe/SecureBootDxe.inf
  SecurityPkg/VariableAuthenticated/SecureBootDefaultKeysDxe/SecureBootDefaultKeysDxe.inf
  Silicon/CIX/Sky1/Drivers/RngDxe/RngDxe.inf
  MdeModulePkg/Universal/CapsuleRuntimeDxe/CapsuleRuntimeDxe.inf
  MdeModulePkg/Universal/MonotonicCounterRuntimeDxe/MonotonicCounterRuntimeDxe.inf
  EmbeddedPkg/ResetRuntimeDxe/ResetRuntimeDxe.inf
  EmbeddedPkg/RealTimeClockRuntimeDxe/RealTimeClockRuntimeDxe.inf
  EmbeddedPkg/MetronomeDxe/MetronomeDxe.inf

  MdeModulePkg/Universal/Console/ConPlatformDxe/ConPlatformDxe.inf
  MdeModulePkg/Universal/Console/ConSplitterDxe/ConSplitterDxe.inf
  MdeModulePkg/Universal/Console/GraphicsConsoleDxe/GraphicsConsoleDxe.inf
  MdeModulePkg/Universal/Console/TerminalDxe/TerminalDxe.inf
  MdeModulePkg/Universal/SerialDxe/SerialDxe.inf
  EmbeddedPkg/Drivers/ConsolePrefDxe/ConsolePrefDxe.inf
  MdeModulePkg/Universal/HiiDatabaseDxe/HiiDatabaseDxe.inf

# ODP: Patina provides ArmGicDxe support
# !if $(DIAGS_KERNEL_ENABLE) == TRUE
#   Edk2OverridePkg/ArmPkg/Drivers/ArmGic/ArmGicDxe.inf
# !else
#   ArmPkg/Drivers/ArmGic/ArmGicDxe.inf
# !endif

  ArmPkg/Drivers/TimerDxe/TimerDxe.inf
  #MdeModulePkg/Universal/WatchdogTimerDxe/WatchdogTimer.inf
  Silicon/CIX/Sky1/Drivers/GenericWatchdogDxe/GenericWatchdogDxe.inf
  MdeModulePkg/Universal/EbcDxe/EbcDxe.inf
  #
  # FAT filesystem + GPT/MBR partitioning
  #
  MdeModulePkg/Universal/Disk/DiskIoDxe/DiskIoDxe.inf
  MdeModulePkg/Universal/Disk/PartitionDxe/PartitionDxe.inf
  MdeModulePkg/Universal/Disk/UnicodeCollation/EnglishDxe/EnglishDxe.inf
  FatPkg/EnhancedFatDxe/Fat.inf
  # FV Filesystem
  #
  # ACPI Support
  #
  MdeModulePkg/Universal/Acpi/AcpiTableDxe/AcpiTableDxe.inf
  # ODP: Extra driver being compiled not included in FDF
  # MdeModulePkg/Universal/Acpi/AcpiPlatformDxe/AcpiPlatformDxe.inf
  Platform/CIX/Sky1/Drivers/AcpiSocTables/AcpiSocTables.inf
  Platform/CIX/Sky1/Drivers/AcpiSocDxe/AcpiSocDxe.inf

  DynamicTablesPkg/Drivers/DynamicTableFactoryDxe/DynamicTableFactoryDxe.inf {
    <LibraryClasses>
      NULL|Platform/CIX/Sky1/Library/Acpi/CIX/AcpiMadtLibCIX/AcpiMadtLibCIX.inf
      NULL|Platform/CIX/Sky1/Library/Acpi/CIX/AcpiSsdtCpuTopologyLibCIX/SsdtCpuTopologyLibCIX.inf
      NULL|Platform/CIX/Sky1/Library/Acpi/CIX/AcpiPpttLibCIX/AcpiPpttLibCIX.inf
  }
  Platform/CIX/Sky1/Drivers/DynamicTableManagerDxe/DynamicTableManagerDxe.inf
  Platform/CIX/Sky1/Drivers/ConfigurationManagerDxe/ConfigurationManagerDxe.inf
  Platform/CIX/Sky1/Drivers/S3SaveStateDxe/S3SaveStateDxe.inf

  #
  # boot logo
  #
  # SMBIOS/DMI
  #
  MdeModulePkg/Universal/SmbiosDxe/SmbiosDxe.inf
  ArmPkg/Universal/Smbios/ProcessorSubClassDxe/ProcessorSubClassDxe.inf
  Platform/CIX/Sky1/Drivers/CixSmbiosDxe/CixSmbiosDxe.inf
  #
  # RAM Disk

  Silicon/CIX/Sky1/Drivers/I2cDxe/I2cDxe.inf
  Platform/CIX/Sky1/Drivers/EcPlatformDxe/EcPlatformDxe.inf
  Platform/CIX/Sky1/Drivers/I2cHidKeyboard/I2cHidKeyboard.inf
  Platform/CIX/Sky1/Drivers/I2cHidServiceDriver/I2cHidServiceDriver.inf
  Platform/CIX/Sky1/Drivers/I2cHidDeviceDxe/I2cHidDeviceDxe.inf

  Silicon/CIX/Sky1/Drivers/SpiDxe/SpiDxe.inf


  Silicon/CIX/Sky1/Drivers/TypecPhyDxe/TypecPhyDxe.inf
  Platform/CIX/Sky1/Drivers/PdDxe/PdDxe.inf {
    <LibraryClasses>
      PdLib|Platform/CIX/Sky1/Library/Rts5453hPdLib/Rts5453hPdLib.inf
      RedriverLib|Platform/CIX/Sky1/Library/PI3DPX1207RedriverLib/PI3DPX1207RedriverLib.inf
  }

  Platform/CIX/Sky1/Drivers/UsbDeviceControlDxe/UsbDeviceControlDxe.inf
  Platform/CIX/Sky1/Application/Fastboot/Fastboot.inf
    Silicon/CIX/Sky1/Drivers/CdnspDxe/CdnspDxe.inf
  Platform/CIX/Sky1/Drivers/LaunchFastbootDxe/LaunchFastbootDxe.inf

  MdeModulePkg/Bus/Pci/NonDiscoverablePciDeviceDxe/NonDiscoverablePciDeviceDxe.inf
  MdeModulePkg/Bus/Pci/UhciDxe/UhciDxe.inf
  MdeModulePkg/Bus/Pci/EhciDxe/EhciDxe.inf
  MdeModulePkg/Bus/Pci/XhciDxe/XhciDxe.inf
  MdeModulePkg/Bus/Usb/UsbBusDxe/UsbBusDxe.inf
  MdeModulePkg/Bus/Usb/UsbMassStorageDxe/UsbMassStorageDxe.inf
  MdeModulePkg/Bus/Usb/UsbKbDxe/UsbKbDxe.inf
  MdeModulePkg/Bus/Usb/UsbMouseDxe/UsbMouseDxe.inf
  Silicon/CIX/Sky1/Drivers/UsbCHostDxe/UsbCHostDxe.inf
  Silicon/CIX/Sky1/Drivers/Usb32HostDxe/Usb32HostDxe.inf
  Silicon/CIX/Sky1/Drivers/Usb20HostDxe/Usb20HostDxe.inf

  # GMAC


  #
  # PCI Support
  #
  ArmPkg/Drivers/ArmPciCpuIo2Dxe/ArmPciCpuIo2Dxe.inf
  MdeModulePkg/Bus/Pci/PciHostBridgeDxe/PciHostBridgeDxe.inf
  Platform/CIX/Sky1/Drivers/Pci/PciBusDxe/PciBusDxe.inf
  EmbeddedPkg/Drivers/NonCoherentIoMmuDxe/NonCoherentIoMmuDxe.inf

  Silicon/CIX/Sky1/Drivers/DpuDxe/DpuDxe.inf {
    <LibraryClasses>
       DisplayLib|Silicon/CIX/Sky1/Library/DisplayLib/DisplayLib.inf
  }

  # ODP: Fix for uninit pointer in precompiled driver
  platform/OVERRIDE/Silicon/CIX/Sky1/Drivers/LcdGraphicsOutputDxe/LcdGraphicsOutputDxe.inf {
    <LibraryClasses>
      DisplayLib|Silicon/CIX/Sky1/Library/DisplayLib/DisplayLib.inf
  }

  #
  # NVMe boot devices
  #
  Platform/CIX/Sky1/Drivers/NvmExpressDxe/NvmExpressDxe.inf

  # SCMI Driver
  Platform/CIX/Sky1/Drivers/ArmScmiDxe/ArmScmiDxe.inf
  # reset
  Silicon/CIX/Sky1/Drivers/ResetDxe/ResetDxe.inf
  # clock
    Silicon/CIX/Sky1/Drivers/ClockDxe/ClockDxe.inf
  # power
  Silicon/CIX/Sky1/Drivers/PowerDxe/PowerDxe.inf
  Platform/CIX/Sky1/Drivers/RealtekLan/RealtekLanDxe.inf

  # Bds
  #
  MdeModulePkg/Universal/BootManagerPolicyDxe/BootManagerPolicyDxe.inf
  MdeModulePkg/Universal/BdsDxe/BdsDxe.inf
  MdeModulePkg/Universal/DevicePathDxe/DevicePathDxe.inf
  MdeModulePkg/Universal/DisplayEngineDxe/DisplayEngineDxe.inf
  MdeModulePkg/Universal/SetupBrowserDxe/SetupBrowserDxe.inf
    MdeModulePkg/Application/UiApp/UiApp.inf {
    <LibraryClasses>
      NULL|MdeModulePkg/Library/BootDiscoveryPolicyUiLib/BootDiscoveryPolicyUiLib.inf
      NULL|MdeModulePkg/Library/DeviceManagerUiLib/DeviceManagerUiLib.inf
      NULL|MdeModulePkg/Library/BootManagerUiLib/BootManagerUiLib.inf
      NULL|MdeModulePkg/Library/BootMaintenanceManagerUiLib/BootMaintenanceManagerUiLib.inf
  }

  MdeModulePkg/Universal/EsrtDxe/EsrtDxe.inf
#  SignedCapsulePkg/Universal/SystemFirmwareUpdate/SystemFirmwareReportDxe.inf
  Platform/CIX/Sky1/Drivers/SystemFirmwareUpdate/SystemFirmwareReportDxe.inf
  Platform/CIX/Sky1/Drivers/ABLUpdate/SystemFirmwareReportDxe.inf
#  SignedCapsulePkg/Universal/SystemFirmwareUpdate/SystemFirmwareUpdateDxe.inf
  MdeModulePkg/Application/CapsuleApp/CapsuleApp.inf {
    <LibraryClasses>
      PcdLib|MdePkg/Library/DxePcdLib/DxePcdLib.inf
  }
#  Platform/CIX/Sky1/Drivers/SystemFirmwareDescriptor/SystemFirmwareDescriptor.inf
  Platform/CIX/Sky1/Drivers/CapsuleUpdateDxe/CapsuleUpdateDxe.inf
  MdeModulePkg/Application/HelloWorld/HelloWorld.inf
  # firmware update protocol
  Platform/CIX/Sky1/Drivers/FirmwareUpdateDxe/FwUpdateProtocolDxe.inf
  Platform/CIX/Sky1/Drivers/FwVersionDxe/FwVersionDxe.inf
  Platform/CIX/Sky1/Drivers/FwVersionDxe/FwVersionProtocolTest.inf
  #
  # UEFI application (Shell Embedded Boot Loader)
  #




  Silicon/CIX/Sky1/Drivers/ArmPsciMpServicesDxe/ArmPsciMpServicesDxe.inf
  # Platform/CIX/Sky1/Drivers/ScmiRuntimeDxe/ScmiRuntimeDxe.inf
  Platform/CIX/Sky1/Drivers/PowerButtonDxe/PowerButtonDxe.inf

  Platform/CIX/Sky1/Drivers/Tcg2Acpi/Tcg2Acpi.inf
  Platform/CIX/Sky1/Drivers/TPMVariableDxe/TPMVariableDxe.inf
  SecurityPkg/Tcg/Tcg2Dxe/Tcg2Dxe.inf {
    <LibraryClasses>
      HashLib|SecurityPkg/Library/HashLibBaseCryptoRouter/HashLibBaseCryptoRouterDxe.inf
      Tpm2DeviceLib|Platform/CIX/Sky1/Library/Tpm2DeviceLib/Tpm2DeviceLib.inf
      NULL|SecurityPkg/Library/Tpm2DeviceLibDTpm/Tpm2InstanceLibDTpm.inf
      NULL|SecurityPkg/Library/HashInstanceLibSha1/HashInstanceLibSha1.inf
      NULL|SecurityPkg/Library/HashInstanceLibSha256/HashInstanceLibSha256.inf
      NULL|SecurityPkg/Library/HashInstanceLibSha384/HashInstanceLibSha384.inf
  }
  Platform/CIX/Sky1/Drivers/Tcg2Config/Tcg2ConfigDxe.inf
## @file
#
#  Copyright 2024 Radxa Computer (Shenzhen) Co., Ltd. All Rights Reserved.
#  Copyright (c) 2018, Linaro Ltd. All rights reserved.
#
#  SPDX-License-Identifier: BSD-2-Clause-Patent
#
##

[Components.common]

[BuildOptions]
  GCC:*_*_*_CC_FLAGS              = -DCOMPILE_BUILD_DATE=$(BUILD_DATE)
!if $(TARGET) == RELEASE
  GCC:*_*_*_CC_FLAGS              = -DUEFI_FW_VERSION=9.0.3
!else
  GCC:*_*_*_CC_FLAGS              = -DUEFI_FW_VERSION=9.0.3"-"$(COMMIT_HASH)"-debug:"$(BUILD_DATE)
!endif

[PcdsFeatureFlag.common]
  # Support VariableInfo.efi
  gEfiMdeModulePkgTokenSpaceGuid.PcdVariableCollectStatistics|TRUE

[PcdsFixedAtBuild.common]
  # Version string
!if $(TARGET) == RELEASE
  gEfiMdeModulePkgTokenSpaceGuid.PcdFirmwareVersionString|L"9.0.3"
!else
  gEfiMdeModulePkgTokenSpaceGuid.PcdFirmwareVersionString|L"9.0.3-$(COMMIT_HASH)-debug:$(BUILD_DATE)"
!endif

  # Code info
  gRadxaTokenSpaceGuid.PcdEdk2CixCommitHash|L"$(COMMIT_HASH)"
  gRadxaTokenSpaceGuid.PcdEdk2CommitHash|L""
  gRadxaTokenSpaceGuid.PcdEdk2NonOSICommitHash|L""
  gRadxaTokenSpaceGuid.PcdEdk2PlatformsCommitHash|L""
[LibraryClasses.common]

  PerformanceLib|MdePkg/Library/BasePerformanceLibNull/BasePerformanceLibNull.inf
  ReportStatusCodeLib|MdeModulePkg/Library/DxeReportStatusCodeLib/DxeReportStatusCodeLib.inf
  PdEcLib|Platform/Radxa/Library/PdEcLibNull/PdEcLibNull.inf


[PcdsFixedAtBuild.common]

  gEfiMdeModulePkgTokenSpaceGuid.PcdSerialRegisterBase|0x040D0000 #0x091e1000 #0x0a051000

  # Default State After G3 is Power On
  gCixTokenSpaceGuid.PcdStateAfterG3|0x01

  # SPCR use UART2
  gArmPlatformTokenSpaceGuid.PcdSerialDbgRegisterBase|0x040D0000
  gArmPlatformTokenSpaceGuid.PcdSerialDbgInterrupt|330
  gCixPlatformTokenSpaceGuid.PcdAcpiSpcrEnable|TRUE

  # Default hardware description should be ACPI
  gEmbeddedTokenSpaceGuid.PcdDefaultDtPref|FALSE
  gCixPlatformTokenSpaceGuid.PcdAcpiSpcrEnable|TRUE

  # Default hardware description should be ACPI
  gEmbeddedTokenSpaceGuid.PcdDefaultDtPref|FALSE

  # Enable performance measurment
  gEfiMdePkgTokenSpaceGuid.PcdPerformanceLibraryPropertyMask|1
  gEfiMdePkgTokenSpaceGuid.PcdReportStatusCodePropertyMask|0x07
  gEfiMdeModulePkgTokenSpaceGuid.PcdExtFpdtBootRecordPadSize|0x300000

  # Must match SYSTEM_FMP_ESRT_GUID
  # gEfiMdeModulePkgTokenSpaceGuid.PcdSystemFmpCapsuleImageTypeIdGuid is defined in Platform/CIX/Sky1/Sky1Common.dsc.inc
  gFmpDevicePkgTokenSpaceGuid.PcdFmpDeviceImageTypeIdGuid|{GUID("351c9808-4b53-4363-9314-d339386e5685")}

[Components.common]

  MdeModulePkg/Universal/SerialDxe/SerialDxe.inf

  Platform/Radxa/Drivers/Logo/LogoDxe.inf

  Platform/Radxa/Platforms/CIX/Sky1/Drivers/SystemInfoDxe/SystemInfoDxe.inf

  Platform/CIX/Sky1/Drivers/PlatformSetupVariableInitDxe/PlatformSetupVariableInitDxe.inf
  Platform/Radxa/Platforms/CIX/Sky1/Drivers/PlatformConfigDxe/PlatformConfigDxe.inf

  Platform/Radxa/Platforms/CIX/Sky1/Drivers/RadxaSetupVariableInitDxe/RadxaSetupVariableInitDxe.inf
  Platform/Radxa/Platforms/CIX/Sky1/Drivers/FirmwareConfigUpdateDxe/FirmwareConfigUpdateDxe.inf
  Platform/Radxa/Platforms/CIX/Sky1/Drivers/SeConfigUpdateDxe/SeConfigUpdateDxe.inf
  EmbeddedPkg/Drivers/DtPlatformDxe/DtPlatformDxe.inf {
    <LibraryClasses>
      DtPlatformDtbLoaderLib|EmbeddedPkg/Library/DxeDtPlatformDtbLoaderLibDefault/DxeDtPlatformDtbLoaderLibDefault.inf
  }

  MdeModulePkg/Application/VariableInfo/VariableInfo.inf

  MdeModulePkg/Universal/Disk/RamDiskDxe/RamDiskDxe.inf

  #
  # AHCI Support
  #
  MdeModulePkg/Bus/Ata/AtaAtapiPassThru/AtaAtapiPassThru.inf
  MdeModulePkg/Bus/Ata/AtaBusDxe/AtaBusDxe.inf

  #
  # SATA Controller
  #
  MdeModulePkg/Bus/Pci/SataControllerDxe/SataControllerDxe.inf

  #
  # Firmware Performance Data Table (FPDT)
  #
  MdeModulePkg/Universal/ReportStatusCodeRouter/RuntimeDxe/ReportStatusCodeRouterRuntimeDxe.inf
  MdeModulePkg/Universal/Acpi/FirmwarePerformanceDataTableDxe/FirmwarePerformanceDxe.inf {
    <LibraryClasses>
      LockBoxLib|MdeModulePkg/Library/LockBoxNullLib/LockBoxNullLib.inf
  }

  MdeModulePkg/Universal/EsrtFmpDxe/EsrtFmpDxe.inf
  FmpDevicePkg/FmpDxe/FmpDxe.inf {
    <Defines>
      #
      # FILE_GUID is used as ESRT GUID
      #
      FILE_GUID = 351c9808-4b53-4363-9314-d339386e5685
    <PcdsFixedAtBuild>
      gFmpDevicePkgTokenSpaceGuid.PcdFmpDeviceImageIdName|L"Radxa System Firmware Device"
  gFmpDevicePkgTokenSpaceGuid.PcdFmpDevicePkcs7CertBufferXdr|{0x00, 0x00, 0x03, 0xF0, 0x30, 0x82, 0x03, 0xEC, 0x30, 0x82, 0x02, 0xD4, 0xA0, 0x03, 0x02, 0x01, 0x02, 0x02, 0x09, 0x00, 0xC0, 0x91, 0xC5, 0xE2, 0xB7, 0x66, 0xC0, 0xF8, 0x30, 0x0D, 0x06, 0x09, 0x2A, 0x86, 0x48, 0x86, 0xF7, 0x0D, 0x01, 0x01, 0x0B, 0x05, 0x00, 0x30, 0x81, 0x82, 0x31, 0x0B, 0x30, 0x09, 0x06, 0x03, 0x55, 0x04, 0x06, 0x13, 0x02, 0x43, 0x4E, 0x31, 0x0B, 0x30, 0x09, 0x06, 0x03, 0x55, 0x04, 0x08, 0x0C, 0x02, 0x53, 0x48, 0x31, 0x0B, 0x30, 0x09, 0x06, 0x03, 0x55, 0x04, 0x07, 0x0C, 0x02, 0x53, 0x48, 0x31, 0x12, 0x30, 0x10, 0x06, 0x03, 0x55, 0x04, 0x0A, 0x0C, 0x09, 0x54, 0x69, 0x61, 0x6E, 0x6F, 0x43, 0x6F, 0x72, 0x65, 0x31, 0x0E, 0x30, 0x0C, 0x06, 0x03, 0x55, 0x04, 0x0B, 0x0C, 0x05, 0x45, 0x44, 0x4B, 0x49, 0x49, 0x31, 0x11, 0x30, 0x0F, 0x06, 0x03, 0x55, 0x04, 0x03, 0x0C, 0x08, 0x54, 0x65, 0x73, 0x74, 0x52, 0x6F, 0x6F, 0x74, 0x31, 0x22, 0x30, 0x20, 0x06, 0x09, 0x2A, 0x86, 0x48, 0x86, 0xF7, 0x0D, 0x01, 0x09, 0x01, 0x16, 0x13, 0x65, 0x64, 0x6B, 0x69, 0x69, 0x40, 0x74, 0x69, 0x61, 0x6E, 0x6F, 0x63, 0x6F, 0x72, 0x65, 0x2E, 0x6F, 0x72, 0x67, 0x30, 0x1E, 0x17, 0x0D, 0x31, 0x37, 0x30, 0x34, 0x31, 0x30, 0x30, 0x38, 0x32, 0x37, 0x34, 0x30, 0x5A, 0x17, 0x0D, 0x31, 0x37, 0x30, 0x35, 0x31, 0x30, 0x30, 0x38, 0x32, 0x37, 0x34, 0x30, 0x5A, 0x30, 0x81, 0x82, 0x31, 0x0B, 0x30, 0x09, 0x06, 0x03, 0x55, 0x04, 0x06, 0x13, 0x02, 0x43, 0x4E, 0x31, 0x0B, 0x30, 0x09, 0x06, 0x03, 0x55, 0x04, 0x08, 0x0C, 0x02, 0x53, 0x48, 0x31, 0x0B, 0x30, 0x09, 0x06, 0x03, 0x55, 0x04, 0x07, 0x0C, 0x02, 0x53, 0x48, 0x31, 0x12, 0x30, 0x10, 0x06, 0x03, 0x55, 0x04, 0x0A, 0x0C, 0x09, 0x54, 0x69, 0x61, 0x6E, 0x6F, 0x43, 0x6F, 0x72, 0x65, 0x31, 0x0E, 0x30, 0x0C, 0x06, 0x03, 0x55, 0x04, 0x0B, 0x0C, 0x05, 0x45, 0x44, 0x4B, 0x49, 0x49, 0x31, 0x11, 0x30, 0x0F, 0x06, 0x03, 0x55, 0x04, 0x03, 0x0C, 0x08, 0x54, 0x65, 0x73, 0x74, 0x52, 0x6F, 0x6F, 0x74, 0x31, 0x22, 0x30, 0x20, 0x06, 0x09, 0x2A, 0x86, 0x48, 0x86, 0xF7, 0x0D, 0x01, 0x09, 0x01, 0x16, 0x13, 0x65, 0x64, 0x6B, 0x69, 0x69, 0x40, 0x74, 0x69, 0x61, 0x6E, 0x6F, 0x63, 0x6F, 0x72, 0x65, 0x2E, 0x6F, 0x72, 0x67, 0x30, 0x82, 0x01, 0x22, 0x30, 0x0D, 0x06, 0x09, 0x2A, 0x86, 0x48, 0x86, 0xF7, 0x0D, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0F, 0x00, 0x30, 0x82, 0x01, 0x0A, 0x02, 0x82, 0x01, 0x01, 0x00, 0xB9, 0x29, 0x29, 0x6C, 0x60, 0x0C, 0xD7, 0x23, 0xF6, 0x7D, 0xEE, 0xF0, 0x62, 0xFF, 0xD9, 0xC9, 0xAA, 0x55, 0x8C, 0x81, 0x95, 0x56, 0x3F, 0xB7, 0x56, 0x53, 0xB0, 0xC2, 0x82, 0x12, 0xC5, 0x3B, 0x75, 0x23, 0xB9, 0x4D, 0xD6, 0xC4, 0x55, 0x73, 0xF3, 0xAA, 0x95, 0xA8, 0x1B, 0xF3, 0x93, 0x7E, 0x9E, 0x40, 0xE4, 0x1D, 0x22, 0x9C, 0x93, 0x07, 0x0B, 0xD7, 0xAA, 0x5B, 0xD7, 0xE4, 0x1A, 0x21, 0x84, 0xD7, 0x63, 0x59, 0x03, 0x50, 0x1F, 0xF5, 0x14, 0x55, 0x93, 0x91, 0x9B, 0xF5, 0x52, 0xB0, 0xBF, 0x0E, 0x5C, 0x68, 0x3B, 0x59, 0x52, 0x98, 0x96, 0x56, 0xE1, 0xAB, 0xC4, 0x43, 0xBB, 0x05, 0x57, 0x78, 0x45, 0x01, 0x9F, 0x58, 0x15, 0x53, 0x0E, 0x11, 0x94, 0x2F, 0x0E, 0xF1, 0xA6, 0x19, 0xA2, 0x6E, 0x86, 0x39, 0x2B, 0x33, 0x8D, 0xC7, 0xC5, 0xEB, 0xEE, 0x1E, 0x33, 0xD3, 0x32, 0x94, 0xC1, 0x59, 0xC4, 0x0C, 0x97, 0x0B, 0x12, 0x48, 0x5F, 0x33, 0xF6, 0x60, 0x74, 0x7D, 0x57, 0xC2, 0x13, 0x2D, 0x7D, 0xA9, 0x87, 0xA3, 0x35, 0xEA, 0x91, 0x83, 0x3F, 0x67, 0x7A, 0x92, 0x1F, 0x01, 0x53, 0x9F, 0x62, 0x5F, 0x99, 0x12, 0xFD, 0x73, 0x1B, 0x2D, 0x9E, 0x2B, 0x6C, 0x34, 0x49, 0xAF, 0x4F, 0x07, 0x8F, 0xC0, 0xE9, 0x6B, 0x9E, 0x5F, 0x79, 0x35, 0xDA, 0x2A, 0x5C, 0x88, 0xEE, 0xF6, 0x48, 0x61, 0xDA, 0x96, 0xE3, 0x48, 0x46, 0xA0, 0x94, 0x1C, 0x9D, 0xF6, 0x5C, 0x87, 0x0E, 0xEF, 0x74, 0x09, 0x91, 0x0D, 0x3D, 0x5A, 0xE7, 0xC5, 0x4C, 0x8A, 0x7A, 0xAC, 0xA1, 0x85, 0xB6, 0x67, 0x44, 0x17, 0x55, 0x52, 0x3A, 0xE8, 0x11, 0x4D, 0x58, 0xA2, 0x93, 0x00, 0x62, 0xEA, 0x7B, 0x80, 0xED, 0xCF, 0xBD, 0xDF, 0x75, 0x80, 0x4B, 0xB9, 0x65, 0x63, 0xAD, 0x0B, 0x4D, 0x74, 0xFA, 0x59, 0x02, 0x03, 0x01, 0x00, 0x01, 0xA3, 0x63, 0x30, 0x61, 0x30, 0x1D, 0x06, 0x03, 0x55, 0x1D, 0x0E, 0x04, 0x16, 0x04, 0x14, 0x16, 0xAA, 0xD6, 0x8E, 0x1B, 0x2D, 0x43, 0xF3, 0x2D, 0xB0, 0x24, 0xAD, 0x36, 0x65, 0x3F, 0xB2, 0xFA, 0xB1, 0x2C, 0xED, 0x30, 0x1F, 0x06, 0x03, 0x55, 0x1D, 0x23, 0x04, 0x18, 0x30, 0x16, 0x80, 0x14, 0x16, 0xAA, 0xD6, 0x8E, 0x1B, 0x2D, 0x43, 0xF3, 0x2D, 0xB0, 0x24, 0xAD, 0x36, 0x65, 0x3F, 0xB2, 0xFA, 0xB1, 0x2C, 0xED, 0x30, 0x0F, 0x06, 0x03, 0x55, 0x1D, 0x13, 0x01, 0x01, 0xFF, 0x04, 0x05, 0x30, 0x03, 0x01, 0x01, 0xFF, 0x30, 0x0E, 0x06, 0x03, 0x55, 0x1D, 0x0F, 0x01, 0x01, 0xFF, 0x04, 0x04, 0x03, 0x02, 0x01, 0x86, 0x30, 0x0D, 0x06, 0x09, 0x2A, 0x86, 0x48, 0x86, 0xF7, 0x0D, 0x01, 0x01, 0x0B, 0x05, 0x00, 0x03, 0x82, 0x01, 0x01, 0x00, 0x95, 0xDE, 0xDF, 0xA4, 0x14, 0xDB, 0x92, 0x22, 0x78, 0x1A, 0xBD, 0x31, 0x9D, 0x1E, 0xD7, 0x2F, 0x0A, 0x10, 0x11, 0x5D, 0x74, 0x61, 0xE8, 0x30, 0xC4, 0xF3, 0x15, 0xE9, 0x30, 0x54, 0xF4, 0xBB, 0x0C, 0x04, 0x78, 0x13, 0x5D, 0x2C, 0xDD, 0x8C, 0x92, 0x90, 0xD1, 0x9C, 0xD0, 0xD0, 0x18, 0xA3, 0xA3, 0xFC, 0x8C, 0x28, 0x5A, 0xD4, 0x91, 0x4D, 0x08, 0xC3, 0xF6, 0x1A, 0xC8, 0xDD, 0xA6, 0x08, 0x58, 0xE2, 0x15, 0x95, 0xFB, 0x2D, 0x2D, 0x8A, 0xB1, 0x30, 0x80, 0xBD, 0x9A, 0xB6, 0xE1, 0x2C, 0x20, 0x3E, 0xDD, 0xC4, 0xC7, 0x55, 0x65, 0xCF, 0x28, 0x17, 0xF4, 0xEE, 0xDA, 0xBE, 0x77, 0x70, 0xD5, 0x52, 0xD6, 0x15, 0x7A, 0xFB, 0xAD, 0xAF, 0xFD, 0xD5, 0x45, 0x90, 0x5A, 0xE6, 0x31, 0x42, 0xD7, 0x84, 0xB3, 0x49, 0x56, 0x6A, 0xD3, 0x47, 0xF3, 0xBF, 0x68, 0x60, 0x8B, 0x0F, 0xE2, 0xAF, 0xF4, 0xE3, 0xEC, 0x12, 0xB9, 0xE2, 0x3A, 0x16, 0x11, 0x4E, 0x4D, 0x73, 0x79, 0xAF, 0x47, 0x85, 0x4C, 0x76, 0x26, 0x9E, 0x8B, 0x32, 0xC0, 0x8E, 0xC2, 0xDC, 0x27, 0xA6, 0xEF, 0xAC, 0x93, 0x9E, 0xA1, 0x5E, 0xCF, 0x34, 0x45, 0xE0, 0x2A, 0xC7, 0x9D, 0x4D, 0xD7, 0xD7, 0x37, 0x72, 0x97, 0xF8, 0x58, 0xF9, 0xB6, 0x35, 0x48, 0xF1, 0xD1, 0x0A, 0x72, 0x7F, 0xFD, 0x4D, 0x7C, 0xE9, 0xCC, 0xD8, 0x48, 0x1B, 0x49, 0x52, 0x53, 0xDE, 0x51, 0x01, 0x53, 0x35, 0xBC, 0x90, 0xCD, 0x8C, 0x8A, 0xCC, 0x43, 0x20, 0xA7, 0x45, 0xFF, 0x2B, 0x55, 0xB0, 0x8B, 0x2D, 0xFF, 0x55, 0x15, 0x4B, 0x84, 0xD0, 0xC3, 0xD3, 0x90, 0x9C, 0x94, 0x4B, 0x55, 0xD5, 0x62, 0xEA, 0x22, 0xAB, 0x62, 0x68, 0xDD, 0x53, 0xC6, 0xDC, 0xA5, 0xDD, 0x9A, 0x2D, 0x8E, 0x79, 0x7C, 0x2E, 0x9C, 0xE4, 0x66, 0x80, 0x8C, 0x1D}
    <LibraryClasses>
      #
      # Generic libraries that are used "as is" by all FMP modules
      #
      FmpPayloadHeaderLib|FmpDevicePkg/Library/FmpPayloadHeaderLibV1/FmpPayloadHeaderLibV1.inf
      FmpAuthenticationLib|SecurityPkg/Library/FmpAuthenticationLibPkcs7/FmpAuthenticationLibPkcs7.inf
      FmpDependencyLib|FmpDevicePkg/Library/FmpDependencyLib/FmpDependencyLib.inf
      FmpDependencyCheckLib|FmpDevicePkg/Library/FmpDependencyCheckLibNull/FmpDependencyCheckLibNull.inf
      FmpDependencyDeviceLib|FmpDevicePkg/Library/FmpDependencyDeviceLibNull/FmpDependencyDeviceLibNull.inf
      #
      # Platform specific capsule policy library
      #
      CapsuleUpdatePolicyLib|FmpDevicePkg/Library/CapsuleUpdatePolicyLibNull/CapsuleUpdatePolicyLibNull.inf
      #
      # Device specific library that processes a capsule and updates the FW storage device
      #
      FmpDeviceLib|FmpDevicePkg/Library/FmpDeviceLibNull/FmpDeviceLibNull.inf
  }
## @file
# Network DSC include file for [Defines] section of all Architectures.
#
# This file can be included to the [Defines] section of a platform DSC file by
# using "!include NetworkPkg/NetworkDefines.dsc.inc" to set default value of
# flags if they are not defined somewhere else, and also check the value to see
# if there is any conflict.
#
# These flags can be defined before the !include line, or changed on the command
# line to enable or disable related feature support.
#   -D FLAG=VALUE
# The default value of these flags are:
#   DEFINE NETWORK_ENABLE                 = TRUE
#   DEFINE NETWORK_SNP_ENABLE             = TRUE
#   DEFINE NETWORK_IP4_ENABLE             = TRUE
#   DEFINE NETWORK_IP6_ENABLE             = TRUE
#   DEFINE NETWORK_TLS_ENABLE             = TRUE
#   DEFINE NETWORK_HTTP_ENABLE            = FALSE
#   DEFINE NETWORK_HTTP_BOOT_ENABLE       = TRUE
#   DEFINE NETWORK_ALLOW_HTTP_CONNECTIONS = FALSE
#   DEFINE NETWORK_ISCSI_ENABLE           = FALSE
#   DEFINE NETWORK_ISCSI_MD5_ENABLE       = TRUE
#   DEFINE NETWORK_VLAN_ENABLE            = TRUE
#
# Copyright (c) 2019, Intel Corporation. All rights reserved.<BR>
# (C) Copyright 2020 Hewlett Packard Enterprise Development LP<BR>
#
#    SPDX-License-Identifier: BSD-2-Clause-Patent
#
##


  #
  # This flag is to include the common SNP driver or not.
  #

  #
  # This flag is to enable or disable VLAN feature.
  #

  #
  # This flag is to enable or disable IPv4 network stack.
  #

  #
  # This flag is to enable or disable IPv6 network stack.
  #

  #
  # This flag is to enable or disable TLS feature.
  #
  # Note: This feature depends on the OpenSSL building. To enable this feature, please
  #       follow the instructions found in the file "OpenSSL-HOWTO.txt" located in
  #       CryptoPkg\Library\OpensslLib to enable the OpenSSL building first.
  #       The OpensslLib.inf library instance should be used since libssl is required.
  #

  #
  # This flag is to enable or disable HTTP(S) feature.
  # The default is set to FALSE to not affecting the existing
  # platforms.
  # NETWORK_HTTP_ENABLE set to FALSE is not affecting NETWORK_HTTP_BOOT_ENABLE
  # when NETWORK_HTTP_BOOT_ENABLE is TRUE.

  #
  # This flag is to enable or disable HTTP(S) boot feature.
  #
  #

  #
  # Indicates whether HTTP connections (i.e., unsecured) are permitted or not.
  #
  # Note: If NETWORK_ALLOW_HTTP_CONNECTIONS is TRUE, HTTP connections are allowed.
  #       Both the "https://" and "http://" URI schemes are permitted. Otherwise, HTTP
  #       connections are denied. Only the "https://" URI scheme is permitted.
  #

  #
  # This flag is to enable or disable iSCSI feature.
  #
  # Note: This feature depends on the OpenSSL building. To enable this feature, please
  #       follow the instructions found in the file "OpenSSL-HOWTO.txt" located in
  #       CryptoPkg\Library\OpensslLib to enable the OpenSSL building first.
  #       Both OpensslLib.inf and OpensslLibCrypto.inf library instance can be used
  #       since libssl is not required for iSCSI.
  #

  #
  # This flag enables the deprecated MD5 hash algorithm in iSCSI CHAP
  # authentication.
  #
  # Note: The NETWORK_ISCSI_MD5_ENABLE flag only makes a difference if
  #       NETWORK_ISCSI_ENABLE is TRUE; otherwise, NETWORK_ISCSI_MD5_ENABLE is
  #       ignored.
  #
  #       With NETWORK_ISCSI_MD5_ENABLE set to TRUE, MD5 is enabled as the
  #       least preferred CHAP hash algorithm. With NETWORK_ISCSI_MD5_ENABLE
  #       set to FALSE, MD5 is disabled statically, at build time.
  #
  #       The default value is TRUE, because RFC 7143 mandates MD5, and because
  #       several vendors' iSCSI targets only support MD5, for CHAP.
  #


################################################################################
#
# Library Class section - list of all Library Classes needed by this Platform.
# Override some library for platform requirement
#
################################################################################

[LibraryClasses.common]
  PlatformConfigParamsHookLib|Platform/Radxa/Orion/O6/Library/PlatformConfigParamsHookLib/PlatformConfigParamsHookLib.inf
  PlatformEnvHookLib|Platform/Radxa/Orion/O6/Library/PlatformEnvHookLib/PlatformEnvHookLib.inf
  RealTimeClockLib|Platform/Radxa/Library/Hym8563RealTimeClockLib/Hym8563RealTimeClockLib.inf

  PlatformBootHookLib|Platform/CIX/Sky1/Merak/Library/PlatformBootHookLib/PlatformBootHookLib.inf

  TrngLib|Silicon/CIX/Sky1/Library/TrngLib/TrngLib.inf
  RngLib|Silicon/CIX/Sky1/Library/RngLib/RngLib.inf
  DtbUpdateLibSi|Platform/CIX/Sky1/Library/DtbUpdateLibSi/DtbUpdateLib.inf

[LibraryClasses.common.DXE_RUNTIME_DRIVER]
  EfiResetSystemLib|Platform/Radxa/Library/ArmPsciResetSystemLib/ArmPsciResetSystemLib.inf
  EcLib|Platform/CIX/Sky1/Library/Ite5570EcLib/Ite5570EcRuntimeLib.inf

################################################################################
#
# Components Section - list of all EDK II Modules needed by this Platform
# Add some INF components for platform requirement
#
################################################################################
[Components.common]
# Network stack
## @file
# Network DSC include file for Platform DSC
#
# This file includes all required information to enable Network features.
# It can be included to a platform DSC file by using "!include NetworkPkg/Network.dsc.inc".
#
# This file defines one build flag PLATFORMX64_ENABLE to support
# IA32 PEI and X64 DXE platform. Its default value is FALSE.
#
# Copyright (c) 2019 - 2020, Intel Corporation. All rights reserved.<BR>
# Copyright (c) 2020, Hewlett Packard Enterprise Development LP. All rights reserved.<BR>
# Copyright (c) 2022, Loongson Technology Corporation Limited. All rights reserved.<BR>
#
#    SPDX-License-Identifier: BSD-2-Clause-Patent
#
##

[Defines]
## @file
# Network DSC include file for [Defines] section of all Architectures.
#
# This file can be included to the [Defines] section of a platform DSC file by
# using "!include NetworkPkg/NetworkDefines.dsc.inc" to set default value of
# flags if they are not defined somewhere else, and also check the value to see
# if there is any conflict.
#
# These flags can be defined before the !include line, or changed on the command
# line to enable or disable related feature support.
#   -D FLAG=VALUE
# The default value of these flags are:
#   DEFINE NETWORK_ENABLE                 = TRUE
#   DEFINE NETWORK_SNP_ENABLE             = TRUE
#   DEFINE NETWORK_IP4_ENABLE             = TRUE
#   DEFINE NETWORK_IP6_ENABLE             = TRUE
#   DEFINE NETWORK_TLS_ENABLE             = TRUE
#   DEFINE NETWORK_HTTP_ENABLE            = FALSE
#   DEFINE NETWORK_HTTP_BOOT_ENABLE       = TRUE
#   DEFINE NETWORK_ALLOW_HTTP_CONNECTIONS = FALSE
#   DEFINE NETWORK_ISCSI_ENABLE           = FALSE
#   DEFINE NETWORK_ISCSI_MD5_ENABLE       = TRUE
#   DEFINE NETWORK_VLAN_ENABLE            = TRUE
#
# Copyright (c) 2019, Intel Corporation. All rights reserved.<BR>
# (C) Copyright 2020 Hewlett Packard Enterprise Development LP<BR>
#
#    SPDX-License-Identifier: BSD-2-Clause-Patent
#
##


  #
  # This flag is to include the common SNP driver or not.
  #

  #
  # This flag is to enable or disable VLAN feature.
  #

  #
  # This flag is to enable or disable IPv4 network stack.
  #

  #
  # This flag is to enable or disable IPv6 network stack.
  #

  #
  # This flag is to enable or disable TLS feature.
  #
  # Note: This feature depends on the OpenSSL building. To enable this feature, please
  #       follow the instructions found in the file "OpenSSL-HOWTO.txt" located in
  #       CryptoPkg\Library\OpensslLib to enable the OpenSSL building first.
  #       The OpensslLib.inf library instance should be used since libssl is required.
  #

  #
  # This flag is to enable or disable HTTP(S) feature.
  # The default is set to FALSE to not affecting the existing
  # platforms.
  # NETWORK_HTTP_ENABLE set to FALSE is not affecting NETWORK_HTTP_BOOT_ENABLE
  # when NETWORK_HTTP_BOOT_ENABLE is TRUE.

  #
  # This flag is to enable or disable HTTP(S) boot feature.
  #
  #

  #
  # Indicates whether HTTP connections (i.e., unsecured) are permitted or not.
  #
  # Note: If NETWORK_ALLOW_HTTP_CONNECTIONS is TRUE, HTTP connections are allowed.
  #       Both the "https://" and "http://" URI schemes are permitted. Otherwise, HTTP
  #       connections are denied. Only the "https://" URI scheme is permitted.
  #

  #
  # This flag is to enable or disable iSCSI feature.
  #
  # Note: This feature depends on the OpenSSL building. To enable this feature, please
  #       follow the instructions found in the file "OpenSSL-HOWTO.txt" located in
  #       CryptoPkg\Library\OpensslLib to enable the OpenSSL building first.
  #       Both OpensslLib.inf and OpensslLibCrypto.inf library instance can be used
  #       since libssl is not required for iSCSI.
  #

  #
  # This flag enables the deprecated MD5 hash algorithm in iSCSI CHAP
  # authentication.
  #
  # Note: The NETWORK_ISCSI_MD5_ENABLE flag only makes a difference if
  #       NETWORK_ISCSI_ENABLE is TRUE; otherwise, NETWORK_ISCSI_MD5_ENABLE is
  #       ignored.
  #
  #       With NETWORK_ISCSI_MD5_ENABLE set to TRUE, MD5 is enabled as the
  #       least preferred CHAP hash algorithm. With NETWORK_ISCSI_MD5_ENABLE
  #       set to FALSE, MD5 is disabled statically, at build time.
  #
  #       The default value is TRUE, because RFC 7143 mandates MD5, and because
  #       several vendors' iSCSI targets only support MD5, for CHAP.
  #


  #
  # PLATFORMX64_ENABLE is set to TRUE when PEI is IA32 and DXE is X64 platform
  #

[PcdsFixedAtBuild]
## @file
# Network DSC include file for [Pcds*] section of all Architectures.
#
# This file can be included to the [Pcds*] section(s) of a platform DSC file
# by using "!include NetworkPkg/NetworkPcds.dsc.inc" to specify PCD settings
# according to the value of flags described in "NetworkDefines.dsc.inc".
#
# Copyright (c) 2019, Intel Corporation. All rights reserved.<BR>
#
#    SPDX-License-Identifier: BSD-2-Clause-Patent
#
##


[LibraryClasses]
## @file
# Network DSC include file for [LibraryClasses*] section of all Architectures.
#
# This file can be included to the [LibraryClasses*] section(s) of a platform DSC file
# by using "!include NetworkPkg/NetworkLibs.dsc.inc" to specify the library instances
# of EDKII network library classes.
#
# Copyright (c) 2019, Intel Corporation. All rights reserved.<BR>
# (C) Copyright 2020 Hewlett Packard Enterprise Development LP<BR>
#
#    SPDX-License-Identifier: BSD-2-Clause-Patent
#
##

  DpcLib|NetworkPkg/Library/DxeDpcLib/DxeDpcLib.inf
  NetLib|NetworkPkg/Library/DxeNetLib/DxeNetLib.inf
  IpIoLib|NetworkPkg/Library/DxeIpIoLib/DxeIpIoLib.inf
  UdpIoLib|NetworkPkg/Library/DxeUdpIoLib/DxeUdpIoLib.inf
  TcpIoLib|NetworkPkg/Library/DxeTcpIoLib/DxeTcpIoLib.inf
  # HttpLib and HttpIoLib are used for Http Boot and other
  # HTTP applications.
  HttpLib|NetworkPkg/Library/DxeHttpLib/DxeHttpLib.inf
  HttpIoLib|NetworkPkg/Library/DxeHttpIoLib/DxeHttpIoLib.inf

[BuildOptions]
## @file
# Network DSC include file for [BuildOptions] sections of all Architectures.
#
# This file can be included in the [BuildOptions*] section(s) of a platform DSC file
# by using "!include NetworkPkg/NetworkBuildOptions.dsc.inc", to specify the C language
# feature test macros (eg., API deprecation macros) according to the flags described
# in "NetworkDefines.dsc.inc".
#
# Supported tool chain families: "GCC", "INTEL", "MSFT".
#
# Copyright (c) 2020, Intel Corporation. All rights reserved.<BR>
#
#    SPDX-License-Identifier: BSD-2-Clause-Patent
#
##


[Components.IA32, Components.X64, Components.ARM, Components.AARCH64, Components.RISCV64, Components.LOONGARCH64]
## @file
# Network DSC include file for [Components*] section of all Architectures.
#
# This file can be included to the [Components*] section(s) of a platform DSC file
# by using "!include NetworkPkg/NetworkComponents.dsc.inc" to specify the INF files
# of EDKII network drivers according to the value of flags described in
# "NetworkDefines.dsc.inc".
#
# Copyright (c) 2019, Intel Corporation. All rights reserved.<BR>
#
#    SPDX-License-Identifier: BSD-2-Clause-Patent
#
##


# Restore the caller's section after the inlined network definitions.
[Components.common]
# This modification is to fix a PXE bug.
# If the Code Base is upgraded, this modification will cause a compilation error and should be deleted.
  NetworkPkg/UefiPxeBcDxe/UefiPxeBcDxe.inf {
    <PcdsFixedAtBuild>
      gEfiNetworkPkgTokenSpaceGuid.PcdIPv4PXESupport|TRUE
      gEfiNetworkPkgTokenSpaceGuid.PcdIPv6PXESupport|TRUE
  }

  Platform/CIX/Sky1/PrePi/PeiUniCore.inf
  ShellPkg/Application/Shell/Shell.inf {
    <LibraryClasses>
      ShellCommandLib|ShellPkg/Library/UefiShellCommandLib/UefiShellCommandLib.inf
      NULL|ShellPkg/Library/UefiShellLevel2CommandsLib/UefiShellLevel2CommandsLib.inf
      NULL|ShellPkg/Library/UefiShellLevel1CommandsLib/UefiShellLevel1CommandsLib.inf
      NULL|ShellPkg/Library/UefiShellLevel3CommandsLib/UefiShellLevel3CommandsLib.inf
      NULL|ShellPkg/Library/UefiShellDriver1CommandsLib/UefiShellDriver1CommandsLib.inf
      NULL|ShellPkg/Library/UefiShellDebug1CommandsLib/UefiShellDebug1CommandsLib.inf
      NULL|ShellPkg/Library/UefiShellInstall1CommandsLib/UefiShellInstall1CommandsLib.inf
      NULL|ShellPkg/Library/UefiShellAcpiViewCommandLib/UefiShellAcpiViewCommandLib.inf
      NULL|ShellPkg/Library/UefiShellNetwork1CommandsLib/UefiShellNetwork1CommandsLib.inf
      HandleParsingLib|ShellPkg/Library/UefiHandleParsingLib/UefiHandleParsingLib.inf
      PrintLib|MdePkg/Library/BasePrintLib/BasePrintLib.inf
      BcfgCommandLib|ShellPkg/Library/UefiShellBcfgCommandLib/UefiShellBcfgCommandLib.inf

    <PcdsFixedAtBuild>
      gEfiShellPkgTokenSpaceGuid.PcdShellLibAutoInitialize|FALSE
      gEfiMdePkgTokenSpaceGuid.PcdUefiLibMaxPrintBufferSize|8000
      gEfiShellPkgTokenSpaceGuid.PcdShellFileOperationSize|0x200000
  }
  Platform/CIX/Sky1/Drivers/DtbUpdateDxeSi/DtbUpdateDxe.inf
  Platform/Radxa/Orion/O6/Drivers/AcpiPlatfomTables/AcpiPlatfomTables.inf
  Platform/Radxa/Drivers/AcpiPlatformDxe/AcpiPlatformDxe.inf
  Platform/Radxa/Orion/O6/Drivers/PlatformSmbios/PlatformSmbios.inf
  Platform/Radxa/Orion/O6/DeviceTree/DeviceTree.inf

###################################################################################################
# BuildOptions Section - Define the module specific tool chain flags that should be used as
#                        the default flags for a module. These flags are appended to any
#                        standard flags that are defined by the build process.
# add some BuildOptions for platform requirement
###################################################################################################
[BuildOptions]
  GCC:DEBUG_*_*_CC_FLAGS          = -DDEBUG_MODE
  GCC:RELEASE_*_*_CC_FLAGS        = -DMDEPKG_NDEBUG -DNDEBUG

  GCC:*_*_*_CC_FLAGS          = -DFASTBOOT_NVME

  GCC:*_*_*_CC_FLAGS              = -DMULTICORE_ENABLE
  GCC:*_*_*_ASLCC_FLAGS           = -DMULTICORE_ENABLE
  GCC:*_*_*_ASLPP_FLAGS           = -DMULTICORE_ENABLE


  GCC:*_*_*_PP_FLAGS              = -DUPDATE_MEMORY_TOP
  GCC:*_*_*_CC_FLAGS              = -DUPDATE_MEMORY_TOP


  GCC:*_*_*_CC_FLAGS              = -DREBOOT_REASON_ENABLE


  GCC:*_*_*_CC_FLAGS              = -DPHYSICAL_PHY

  GCC:*_*_*_CC_FLAGS              = -DFV_MAIN_COMPRESSED

  GCC:*_*_*_CC_FLAGS              = -DDYNAMIC_ACPI_CPU_ENABLE
  GCC:*_*_*_ASLPP_FLAGS           = -DDYNAMIC_ACPI_CPU_ENABLE
  GCC:*_*_*_ASLPP_FLAGS           = -DDYNAMIC_ACPI_CPU_ENABLE


  GCC:*_*_*_ASLPP_FLAGS           = -DLINUX_ACPI_CONFIG_OVERRIDE
  # ODP: This should be in the .inf to pull in the proper .dec
  GCC:*_*_*_ASLPP_FLAGS           = -I$(WORKSPACE)/../../common/cix-edk2-platforms/Platform/Radxa/Orion/O6/Drivers

  GCC:*_*_*_CC_FLAGS              = -DSTMM_SUPPORT

  GCC:*_*_*_VFRPP_FLAGS       = -DFW_CONFIG_UPDATE_SUPPORT=1

################################################################################
#
# Pcd Section - list of all EDK II PCD Entries defined by this Platform
# Override some PCD define for platform requirement
#
################################################################################
[PcdsFixedAtBuild.common]
  gCixPlatformTokenSpaceGuid.PcdSiliconDtbUpdateFileName|L"sky1-orion-o6.dtb"
  gCixPlatformTokenSpaceGuid.PcdSiliconDtbUpdateEnable|TRUE

  gCixTokenSpaceGuid.PcdPcieRootPort0Enable|TRUE
  gCixTokenSpaceGuid.PcdPcieRootPort1Enable|TRUE
  gCixTokenSpaceGuid.PcdPcieRootPort2Enable|TRUE
  gCixTokenSpaceGuid.PcdPcieRootPort3Enable|TRUE
  gCixTokenSpaceGuid.PcdPcieRootPort4Enable|TRUE
  gCixTokenSpaceGuid.PcdPcieRootPort0MaxSpeed|0x03
  gCixTokenSpaceGuid.PcdPcieRootPort1MaxSpeed|0x03
  gCixTokenSpaceGuid.PcdPcieRootPort2MaxSpeed|0x03
  gCixTokenSpaceGuid.PcdPcieRootPort3MaxSpeed|0x03
  gCixTokenSpaceGuid.PcdPcieRootPort4MaxSpeed|0x03
  gCixTokenSpaceGuid.PcdPcieRootPort0LaneNum|0x03
  gCixTokenSpaceGuid.PcdPcieRootPort1LaneNum|0x02
  gCixTokenSpaceGuid.PcdPcieRootPort2LaneNum|0x01
  gCixTokenSpaceGuid.PcdPcieRootPort3LaneNum|0x00
  gCixTokenSpaceGuid.PcdPcieRootPort4LaneNum|0x00
  gCixTokenSpaceGuid.PcdPcieRootPort0PeResetPin|2
  gCixTokenSpaceGuid.PcdPcieRootPort1PeResetPin|4
  gCixTokenSpaceGuid.PcdPcieRootPort2PeResetPin|5
  gCixTokenSpaceGuid.PcdPcieRootPort3PeResetPin|3
  gCixTokenSpaceGuid.PcdPcieRootPort4PeResetPin|6

  gCixTokenSpaceGuid.PcdI2c2En|FALSE
  gCixTokenSpaceGuid.PcdI2c2BusFreq|100000
  gCixTokenSpaceGuid.PcdI2c3En|TRUE
  gCixTokenSpaceGuid.PcdI2c3Runtime|TRUE          # For RTC runtime service
  gCixTokenSpaceGuid.PcdI2c3BusFreq|100000
  gCixTokenSpaceGuid.PcdI2c4En|TRUE
  gCixTokenSpaceGuid.PcdI2c4BusFreq|100000
  gCixTokenSpaceGuid.PcdI2c5En|TRUE
  gCixTokenSpaceGuid.PcdI2c5BusFreq|100000
  gCixTokenSpaceGuid.PcdI2c6En|TRUE
  gCixTokenSpaceGuid.PcdI2c6BusFreq|50000

  # PD
  gCixTokenSpaceGuid.PcdI2c0En|TRUE
  gCixTokenSpaceGuid.PcdI2c0BusFreq|100000
  gCixTokenSpaceGuid.PcdI2c1En|TRUE
  gCixTokenSpaceGuid.PcdI2c1BusFreq|100000
  gCixTokenSpaceGuid.PcdI2c7En|TRUE
  gCixTokenSpaceGuid.PcdI2c7BusFreq|100000

  # RTC I2C canot be controlled in setup
  gCixTokenSpaceGuid.PcdI2cCtrlEn|0xF7

  gCixPlatformTokenSpaceGuid.PcdPdDevI2cBuses|{ 0x1, 0xFF, 0x1, 0xFF }
  gCixPlatformTokenSpaceGuid.PcdPdDevI2cSlaveAddresses|{ 0x30, 0xFF, 0x31, 0xFF }
  gCixPlatformTokenSpaceGuid.PcdPdDevAlertPins|{ 9, 0xFF, 9, 0xFF }
  gCixPlatformTokenSpaceGuid.PcdTypecPortDefaultModes|{ 1, 4, 1, 4}

  # USB3_A
  gCixTokenSpaceGuid.PcdUsb3Control0Enable|TRUE
  gCixTokenSpaceGuid.PcdUsb3Control1Enable|TRUE

  # USBC0
  gCixTokenSpaceGuid.PcdUsbCDrdControl0Enable|TRUE
  gCixTokenSpaceGuid.PcdUsbCDrdControl0DataRole|FALSE
  # USBC1
  gCixTokenSpaceGuid.PcdUsbCControl0Enable|TRUE
  # USBC2
  gCixTokenSpaceGuid.PcdUsbCControl1Enable|TRUE
  # USBC3
  gCixTokenSpaceGuid.PcdUsbCControl2Enable|TRUE

  gCixTokenSpaceGuid.PcdUsb2Control0Enable|TRUE
  gCixTokenSpaceGuid.PcdUsb2Control1Enable|TRUE
  gCixTokenSpaceGuid.PcdUsb2Control2Enable|TRUE
  gCixTokenSpaceGuid.PcdUsb2Control3Enable|TRUE

  gCixTokenSpaceGuid.PcdAcpiI2s5Enable|FALSE
  gCixTokenSpaceGuid.PcdAcpiI2s6Enable|FALSE
  gCixTokenSpaceGuid.PcdAcpiI2s7Enable|FALSE
  gCixTokenSpaceGuid.PcdAcpiI2s8Enable|FALSE
  gCixTokenSpaceGuid.PcdAcpiI2s9Enable|FALSE

  gArmTokenSpaceGuid.PcdSystemMemorySize|0x400000000
  gEfiNetworkPkgTokenSpaceGuid.PcdNetworkStackSupport|FALSE
  gEfiNetworkPkgTokenSpaceGuid.PcdIPv4PXESupport|TRUE
  gEfiNetworkPkgTokenSpaceGuid.PcdIPv6PXESupport|TRUE
  gEfiNetworkPkgTokenSpaceGuid.PcdIPv4HttpSupport|TRUE
  gEfiNetworkPkgTokenSpaceGuid.PcdIPv6HttpSupport|TRUE

  gCixTokenSpaceGuid.PcdSpi0En|TRUE
# ISP Camera Power
  gCixTokenSpaceGuid.PcdIspCamera0Power|0x00
  gCixTokenSpaceGuid.PcdIspCamera1Power|0x00
  gCixTokenSpaceGuid.PcdIspCamera2Power|0x00
  gCixTokenSpaceGuid.PcdIspCamera3Power|0x00

  gCixPlatformTokenSpaceGuid.PcdEcAcpiI2cEn|TRUE
  gCixPlatformTokenSpaceGuid.PcdAcpiGpio0IoMask|0x20000000 # vbus for usb port6-7
  gCixPlatformTokenSpaceGuid.PcdAcpiGpio3IoMask|0x00018000 # pwm/edp en pin output

# Platform specific defaults
  # Set SMBIOS product name
  gArmTokenSpaceGuid.PcdSystemProductName|L"Radxa Orion O6"

  # RTC (taken from Phecda PcdI2c3BusFreq)
  gHym8563RealTimeClockLibTokenSpaceGuid.PcdI2cBusFrequency|100000

  # Fill in dpu index to config display priority
  # Index | Output Name
  # ------|------------
  #     0 | USB-C 0
  #     1 | HDMI
  #     2 | eDP
  #     3 | USB-C 1
  #     4 | DP
  gCixTokenSpaceGuid.PcdDPPriority0|1 # highest priority
  gCixTokenSpaceGuid.PcdDPPriority1|4 #
  gCixTokenSpaceGuid.PcdDPPriority2|0 #
  gCixTokenSpaceGuid.PcdDPPriority3|3 #
  gCixTokenSpaceGuid.PcdDPPriority4|2 # lowest priority

  gCixPlatformTokenSpaceGuid.PcdAcpiPrefPmProf|0x01  # Desktop
  gCixTokenSpaceGuid.PcdAcpiCsiDmaEnable|FALSE

  # Change for SystemReady
  gCixTokenSpaceGuid.PcdCpuCore2En|FALSE
  gCixTokenSpaceGuid.PcdCpuCore3En|FALSE
  gCixTokenSpaceGuid.PcdCpuCore4En|FALSE
  gCixTokenSpaceGuid.PcdCpuCore5En|FALSE
  gCixTokenSpaceGuid.PcdAcpiCpuLpiState|0x1
  gCixTokenSpaceGuid.PcdAcpiCppcType|0x02
  gCixTokenSpaceGuid.PcdStateAfterG3|0x0
  gCixPlatformTokenSpaceGuid.PcdAcpiSpcrEnable|TRUE

  gCixPlatformTokenSpaceGuid.PcdDTPMSupport|TRUE
  gCixPlatformTokenSpaceGuid.PcdFTPMSupport|FALSE
  gCixPlatformTokenSpaceGuid.PcdDTPMSpiBus|0x0          # 0:SPI1=0x04090000  1:SPI2=0x040A0000
  gCixPlatformTokenSpaceGuid.PcdDTPMSpiChipSelect|0x1   # 1:Slave Select 0   2:Slave Select 1
  gCixPlatformTokenSpaceGuid.PcdActiveTpmInterfaceType|0x01

  gCixTokenSpaceGuid.PcdAcpiUart0Enable|FALSE
  gCixTokenSpaceGuid.PcdAcpiCIXUart1DriverEnable|TRUE

[PcdsDynamicDefault.common]

  gEmbeddedTokenSpaceGuid.PcdDmaDeviceLimit|0x47fffffff

  gEfiMdeModulePkgTokenSpaceGuid.PcdVideoHorizontalResolution|1920
  gEfiMdeModulePkgTokenSpaceGuid.PcdVideoVerticalResolution|1080
  gEfiMdeModulePkgTokenSpaceGuid.PcdSetupVideoHorizontalResolution|800
  gEfiMdeModulePkgTokenSpaceGuid.PcdSetupVideoVerticalResolution|600

  gCixPlatformTokenSpaceGuid.PcdDynamicUint64Test|0x11111111
  gEfiSecurityPkgTokenSpaceGuid.PcdTpmInstanceGuid|{0x5a, 0xf2, 0x6b, 0x28, 0xc3, 0xc2, 0x8c, 0x40, 0xb3, 0xb4, 0x25, 0xe6, 0x75, 0x8b, 0x73, 0x17}

[PcdsDynamicHii.common.DEFAULT]
