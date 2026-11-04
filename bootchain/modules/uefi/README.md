# UEFI Firmware

## Overview

This module builds the UEFI firmware (BL33) for the Radxa Orion O6 platform,
based on the TianoCore EDK II framework. The resulting firmware image provides
platform initialization, ACPI tables, driver dispatch, and boot services for the
CIX Sky1 SoC.

## Source

| Directory | Description |
| --- | --- |
| `edk2/` | TianoCore EDK II core (submodule) |
| `platform/` | Platform-specific DSC, FDF, drivers, and Rust modules |

Additional platform packages are referenced from the shared common tree
(`common/cix-edk2-platforms` and `common/cix-edk2-non-osi`).

## Packaged Boot Support

[O6.fdf](platform/O6.fdf) retains NVMe, USB host storage and input, the embedded
UEFI shell, and both ACPI and device-tree OS boot. Serial and graphical consoles,
setup, Secure Boot, TPM, SMBIOS, runtime services, and platform initialization
remain included. The remaining drivers keep their original order and DEPEX
overrides.

The static pruning pass removes 18 INF entries (121 to 103):

| Removed modules | Reason |
| --- | --- |
| `RtkUndiDxe` | Onboard network boot is not required; no network boot stack is packaged. |
| `CapsuleRuntimeDxe`, `EsrtDxe`, `SystemFirmwareReportDxe`, `CapsuleUpdateDxe`, `EsrtFmpDxe`, `FmpDxe` | Capsule processing, FMP update providers, and ESRT publication form the excluded OS firmware-update path. |
| `CdnspDxe`, `UsbDeviceControlDxe`, `Fastboot`, `LaunchFastbootDxe` | USB-device Fastboot boot/recovery is excluded. USB host drivers remain. |
| `SataControllerDxe`, `AtaAtapiPassThru`, `AtaBusDxe` | SATA/AHCI boot is excluded. NVMe and USB mass storage do not depend on this ATA stack. |
| `EbcDxe`, `X86EmulatorDxe` | EBC and x86 application/option-ROM execution are excluded. Native AArch64 applications and GOP drivers remain. |
| `RamDiskDxe` | No retained boot path creates RAM disks. The boot-manager RAM-disk consumer serves network filesystem boot; HTTP boot is not packaged. Shell handle-parser references only name the protocol. This also removes the RAM-disk setup page. |
| `FwVersionProtocolTest` | Only dumps version information; it provides no service. The actual firmware-version provider and setup information page remain. |

The two capsule-authentication certificate files are also omitted. Secure Boot
PK/KEK/db/dbx payloads remain.

Protocol references alone are not sufficient grounds for removal. The audit
includes recursive DSC-selected libraries, source call sites, and the supplied
binary drivers' DEPEX. In particular:

- Keep `FwUpdateProtocolDxe` and `FirmwareConfigUpdateDxe`: the setup-save callback
  uses the raw flash-update protocol to persist memory configuration. These are
  not solely capsule-update components.
- Keep `DevicePathDxe`, HII, and the setup/display engines: the boot menu and
  configuration pages consume their interfaces.
- Keep the USB host controllers, non-discoverable PCI adapter, USB bus, storage,
  keyboard, and mouse drivers, including legacy UHCI/EHCI controller support.
  Keep Type-C PHY, PD, I2C, DPU, and GOP support for USB/display initialization.
- Keep S3 save-state and SPI support: retained platform/reset/I2C and TPM
  libraries depend on them. Keep RNG, ACPI/SMBIOS tables, and runtime services
  even where their consumers are OS loaders or the OS rather than DXE drivers.

[O6.dsc](platform/O6.dsc) builds the retained FDF component set. Its cleanup
removes 16 component definitions; the removed UNDI and x86-emulator binaries
were packaged directly by the FDF and had no DSC component definitions.

The dependency cleanup also removes:

- Ten library mappings/injections: `BmpSupportLib`, `PartitionLib`,
  `FlashUpdateLib`, `FchDmaLib`, `EdkiiSystemCapsuleLib`, `FmpAuthenticationLib`,
  `CixGPNVLib`, `NetLib`, the runtime-only `CapsuleLib` mapping, and the shell
  network-command library. The shell no longer includes `ping` or `ifconfig`.
- Seven component-scoped library overrides belonging to the removed FMP and
  USB-device drivers.
- Six PCD overrides: the system-firmware image descriptor, capsule image-type
  GUID, firmware-file GUID, FMP device image-type GUID, and the removed FMP
  component's image-name and certificate-buffer overrides.

The null `CapsuleLib` remains because the boot manager calls its no-op capsule
hooks. Network-stack and HTTP-support PCD values remain because retained
platform initialization and setup pages use them; in particular, keep
`PcdNetworkStackSupport` set to `FALSE`. Removing a PCD override can restore a
different DEC default, so prune only settings outside the retained dependency
closure.

Static checks cannot establish hardware boot equivalence or fully characterize
opaque vendor binaries. Validate NVMe boot, USB storage and input, shell launch,
ACPI/device-tree boot, and setup-save behavior on hardware before deployment.

## Build

This module is built as part of the bootchain `make all` target. It can
also be built directly from the `bootchain/` directory:

```bash
make -C modules/uefi
```

### Key Build Parameters

| Parameter | Value |
| --- | --- |
| Architecture | AArch64 |
| Toolchain | GCC5 |
| Build Type | `target=debug`: DEBUG; `target=release`: RELEASE |
| Debug Output | `target=debug`: enabled; `target=release`: EDK II `DEBUG()` and `ASSERT()` compiled out via `MDEPKG_NDEBUG`, Patina logging compiled out via `log/release_max_level_off` |
| Serial Console | Platform UART library retained for both build targets |
| Platform DSC | `platform/O6.dsc` |
| Variable Store | SPI flash |
| Secure MM | StandaloneMM (via OP-TEE) |

### Rust Components

The build includes Rust-based DXE drivers (e.g., `PatinaDxeCore_ru`). Rust code
is checked for formatting (`cargo fmt`) and warnings-as-errors (`cargo clippy`)
before compilation.
Debug builds use Cargo's dev profile; release builds use `--release` with size
optimization and debug symbols retained. The firmware packages the matching
profile's DXE Core binary.

## Additional Targets

| Target | Description |
| --- | --- |
| `make test` | Run Rust unit tests on the host |
| `distclean` | Clean EDK II BaseTools build artifacts |

## Output

| Artifact | Description |
| --- | --- |
| `SKY1_BL33_UEFI.fd` | UEFI firmware flash image |

The output binary is placed in the final bootchain binaries directory for
inclusion in the stitched firmware image.
