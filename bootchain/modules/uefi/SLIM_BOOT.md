# Slim Boot

The UEFI image is slimmed to boot Windows from NVMe with the minimum number of drivers.  Anything not needed for
that path was removed from `platform/O6.fdf` and `platform/O6.dsc`, and the few things only needed when NVMe
boot fails (USB, display, console, shell) are kept in a **fallback tier** that is not dispatched at boot.

Measured with the debug target: the compressed firmware volume went from 97% to 64% full, and the uncompressed
`FvMain` from 14.1 MB to 8.05 MB.

## Boot flow

1. Patina DXE core dispatches the **core tier** (47 drivers, listed below).
2. Patina calls the BDS architectural protocol, provided by `SlimBdsDxe`
   ([`Drivers/SlimBdsDxe`](platform/Drivers/SlimBdsDxe)), which:
   1. fills in the firmware vendor/revision in the system table,
   2. signals EndOfDxe (`SecureBootDxe` enrolls the default keys on this event),
   3. connects the PCIe root bridges and boots `\EFI\Microsoft\Boot\bootmgfw.efi`, then `\EFI\BOOT\BOOTAA64.EFI`,
      from every NVMe file system (ReadyToBoot is signaled first because the ACPI tables are finalized by
      ReadyToBoot callbacks, and the UEFI boot watchdog is armed as the stock BDS did).
3. Only if that fails, `SlimBdsDxe` loads the **fallback tier** from the firmware volume in the order listed in
   [`SlimBdsFallback.h`](platform/Drivers/SlimBdsDxe/SlimBdsFallback.h) and starts
   [`SlimFallbackBdsApp`](platform/Drivers/SlimFallbackBdsApp), which brings up the display and USB keyboard
   console, boots USB media, then runs the UEFI shell.

The fallback files are packaged as FFS `APPLICATION` files (FDF rules `*.FALLBACK` and `*.BINARY_FALLBACK`), so
the dispatcher never runs them.  The order in the header is the order the baseline dispatcher loaded them.

## Core tier (dispatched at boot)

| Driver | Why it stays |
| --- | --- |
| PcdDxe | PCD protocol, required by nearly every driver. |
| RuntimeDxe | Runtime architectural protocol. |
| ArmScmiDxe, PowerDxe, ClockDxe, ResetDxe | SCMI clock/power/reset services used by PCIe init and the SoC drivers. PowerDxe/ClockDxe/ResetDxe are binary-only, so they were kept rather than analyzed. |
| S3SaveStateDxe | Protocol the Reset, I2C and EC drivers wait on. |
| SocDxe | SoC information (binary-only, kept). |
| ArmMmCommunication, NorFlashStmmRuntimeDxe, VariableSmmRuntimeDxe | Variable store through StandaloneMM (Variable and Variable Write architectural protocols). |
| ArmTimerDxe, GenericWatchdogDxe, MetronomeDxe | Timer, Watchdog and Metronome architectural protocols (Patina provides CPU/GIC). |
| PlatformConfigParamsManageDxe, ConfigParamsManageDxe | Platform configuration consumed by the ACPI, PCIe and I2C drivers. |
| PlatformSetupVariableInitDxe | Default setup variables; its protocol is consumed by GenericWatchdogDxe. |
| PlatformDxe | Platform init; also installs the protocol the RTC driver waits on. |
| SecurityStubDxe (+ image verification) | Security/Security2 architectural protocols and Secure Boot image verification. |
| SecureBootDefaultKeysDxe, SecureBootDxe, PK/KEK/DB/DBT/DBX files | Default Secure Boot key provisioning. |
| RngDxe | `EFI_RNG_PROTOCOL` for the OS loader. |
| CapsuleRuntimeDxe | Capsule architectural protocol (runtime `UpdateCapsule`). |
| MonotonicCounterRuntimeDxe, ResetRuntimeDxe, RealTimeClockRuntimeDxe | Remaining architectural protocols / runtime services. |
| I2cDxe | I2C master, required by the runtime RTC. |
| EcPlatformDxe | Feeds `FwVersionDxe` (compact FV), which publishes the EC board ID/version to shared memory outside UEFI. [Unverified] whether anything reads it. |
| ConSplitterDxe | Only provides the always-present virtual console handles in the system table so OS loaders never see a NULL `ConOut`/`ConIn`. |
| DiskIoDxe, PartitionDxe, Fat, EnglishDxe | Read the EFI system partition (EnglishDxe provides the unicode collation FAT requires). |
| AcpiTableDxe, AcpiSocTables, AcpiSocDxe, ConfigurationManagerDxe, DynamicTableFactoryDxe, DynamicTableManagerDxe, AcpiPlatfomTables, AcpiPlatformDxe | ACPI tables. |
| ArmPciCpuIo2Dxe, PciHostBridgeDxe, PciBusDxe, NonCoherentIoMmuDxe, NvmExpressDxe, PcieInitDxe | PCIe and NVMe. |
| DevicePathDxe | UEFI-specification device path protocols; kept because an OS loader may rely on them. [Unverified] that Windows does. |
| SlimBdsDxe | BDS (above). |

## Fallback tier (loaded only if NVMe boot fails)

TypecPhyDxe, UsbCHostDxe, Usb32HostDxe, Usb20HostDxe, HiiDatabase, DpuDxe, PdDxe, NonDiscoverablePciDeviceDxe,
XhciDxe, UsbBusDxe, UsbMassStorageDxe, UsbKbDxe, ConPlatformDxe, GraphicsConsoleDxe, LcdGraphicsOutputDxe,
SlimFallbackBdsApp and the UEFI Shell.

## Removed

| Driver(s) | Reason |
| --- | --- |
| CdnspDxe, UsbDeviceControlDxe, Fastboot, LaunchFastbootDxe | USB device mode / fastboot. |
| UhciDxe, EhciDxe | The SoC USB controllers are XHCI. |
| UsbMouseDxe | No pointing device needed. |
| TerminalDxe, SerialDxe, ConsolePrefDxe | Serial/terminal console. The UART debug output is a separate library and is unaffected. |
| I2cHidKeyboard, I2cHidServiceDriver, I2cHidDeviceDxe | I2C HID input (not present on this board). |
| PowerButtonDxe, EbcDxe | Not needed to boot. |
| BdsDxe, BootManagerPolicyDxe, UiApp, DisplayEngineDxe, SetupBrowserDxe, SecureBootConfigDxe, SystemInfoDxe, PlatformConfigDxe, RadxaSetupVariableInitDxe, LogoDxe | Stock BDS, setup UI and HII configuration pages. The Radxa setup variable is only read by the removed config pages. |
| SpiDxe | Its only consumers were BdsDxe and the TPM drivers. |
| SmbiosDxe, ProcessorSubClassDxe, CixSmbiosDxe, PlatformSmbios | SMBIOS. [Unverified] that Windows boots without it. |
| TPMVariableDxe, Tcg2Dxe, Tcg2Acpi, Tcg2ConfigDxe | TPM / measured boot. See the risks below. |
| EsrtDxe, EsrtFmpDxe, FmpDxe, SystemFirmwareReportDxe, CapsuleUpdateDxe, FwUpdateProtocolDxe, FwVersionProtocolTest, FirmwareConfigUpdateDxe, SeConfigUpdateDxe, `ntroot.cer`, `Pkcs7TestRoot` | Firmware/config update through the OS or capsules. The board is flashed with a programmer. |
| DtPlatformDxe, DtbUpdateDxe, DeviceTree | Device tree for non-ACPI OSes. |
| RamDiskDxe | Nothing depends on it. `UefiBootManagerLib` and `LaunchEfiLib` locate it only when booting from a RAM disk path. |
| AtaAtapiPassThru, AtaBusDxe, SataControllerDxe | SATA. |
| X86EmulatorDxe, AmdGop | PCIe GPU option ROM support (AmdGop already failed to load in the baseline log: section alignment). |
| ReportStatusCodeRouterRuntimeDxe, FirmwarePerformanceDxe | Status code routing and FPDT. |
| RtkUndiDxe, VariableInfo | NIC driver and a diagnostic tool. |

`FwVersionDxe` and `PeiUniCore` live in `FVMAIN_COMPACT` rather than `FvMain` and were not changed.

## Risks and what to restore first

These removals are the most likely to matter, in the order to put them back if Windows does not boot or
misbehaves.  Everything here is untested on hardware.

1. **No GOP/display in the core tier.** [Unverified] whether `bootmgfw.efi` needs a graphics output to start.
   Move TypecPhyDxe, DpuDxe, PdDxe and LcdGraphicsOutputDxe (keep this relative order, it is the baseline load
   order) from the fallback rules into the core list.
2. **SMBIOS.** Restore SmbiosDxe, ProcessorSubClassDxe, CixSmbiosDxe, PlatformSmbios (ProcessorSubClassDxe needs
   HiiDatabase in the core tier).
3. **TPM.** Windows 11 expects a TPM 2.0. [Unverified] how Windows behaves with the SoC DSDT's `MSFT0101` node and
   no TPM2 ACPI table. Restoring needs HiiDatabase and SpiDxe in the core tier plus the four TPM drivers; their
   dependency expressions require both.
4. **USB, Type-C and display hardware is not initialized on the NVMe path.** Those drivers now run only in the
   fallback tier. [Unverified] whether Windows initializes that hardware itself.

To move a driver between tiers, change its `INF` line in `O6.fdf` (add or remove `RuleOverride = FALLBACK` or
`BINARY_FALLBACK`) and, for the fallback tier, keep `SlimBdsFallback.h` in step.  Every entry in that header
must match a packaged `APPLICATION` file GUID.

## How this was checked

* The FV builds for the debug and release targets.
* The packaged dependency expressions of all 47 core drivers were decoded from the built FV and replayed in FV
  order: every driver becomes dispatchable and all fourteen architectural protocols are produced.
* Every GUID in `SlimBdsFallback.h` was matched to an `APPLICATION` file in the built FV.
* Not checked: anything that runs on hardware.
