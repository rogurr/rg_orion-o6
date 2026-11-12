# Patina DXE core demonstration: Radxa Orion O6

## Executive summary



## What changed and why

| Change | Reason |
| --- | --- |
| Add the [Rust platform entry point](src/main.rs), pinned dependencies, and toolchain | Supply the O6 UART/GIC configuration and enter unmodified Patina 21.0.3. |
| Replace the C core with a Patina `DXE_CORE` FFS file | Let the existing CIX PrePi loader load Patina through its existing DXE handoff. |
| Omit the C CPU and GIC drivers | Patina supplies those facilities. Keep the existing timer and runtime drivers. |
| Emit the 17 remaining stock APRIORI drivers first, with TRUE dependencies | Reproduce ODP's workaround for Patina not honoring APRIORI, without converting all driver dependencies to TRUE. |
| Produce Resource Descriptor v2 HOBs with explicit cache attributes; describe lower and upper MMIO | Supply the memory description used by the ODP Patina implementation without replacing the entire CIX platform library. |
| Skip duplicate NOR MMIO registration and describe the O6's 8 MiB device | The new MMIO HOB already registers that range. This follows the ODP NOR override. |
| Use the existing source workspace and retain DEBUG/RELEASE output directories | Keep the demonstration Patina-only without separate core-selection workspaces. |
| Apply the patch with a standalone script, build Rust with plain Cargo, and retain vendor UEFI compilation/packaging | Keep the demonstration's preparation separate from the documented Radxa build process. |
| Reference Cargo's normal output directly and package O6 only | Remove custom path definitions and the demo makefile without building unsupported O6N firmware. |

The [README](README.md#existing-source-changes) maps every changed stock file
to its purpose. The [patch](patches/edk2-platforms.patch) preserves the changes
in the parent repository; dirty submodule files alone are not a distributable
integration.

## Scope decisions

- Use the **Radxa ODP implementation**, not the Qualcomm platform code.
  The Qualcomm export supplied the root-folder, executive-summary,
  and inline-annotation pattern only.
- Do not import ODP's reduced DSC/FDF driver configuration, Windows-specific
  changes, new secure services, graphics binaries, or TF-A/OP-TEE patches.
- Do not expand the UEFI flash region or remove stock drivers to make room.
  The Rust dev profile uses size optimization and LTO with INFO logging retained.
  Only LZMA and CRC32 extractors are included; the stock O6 FDF does not use
  Brotli. An unoptimized development-profile Rust core exceeded the existing region.
- Retain ODP's `compatibility_mode_allowed` feature. Production hardening,
  replacing the APRIORI workaround with real dependencies, and other boards
  are outside this demonstration.

## Validation completed

- Rust formatting and Clippy with warnings treated as errors.
- Plain `cargo build`, followed by Patina DEBUG and RELEASE firmware and
  full/OTA flash packaging through the normal workspace-root build entry point.
- Binary inspection of both Patina firmware volumes: exactly one core with the
  required GUID and the exact built Rust PE image; 17 ordered TRUE-dependency
  drivers; no duplicate FFS GUIDs or APRIORI file; all 124 remaining stock
  driver GUIDs retained, with only the CPU/GIC drivers excluded.
- The original `0x220000`-byte UEFI image and 8 MiB full flash image sizes.
- The final Patina SPI images contain the exact validated UEFI FD in their FIP.
- Updated unconditional patch application against the original index, reverse applicability, and
  idempotent application to the modified checkout.

The `make deb` wrapper was invoked, but this host lacks `debuild` from
`devscripts`; Debian package creation was therefore not completed.

**Not validated:** full Debian package creation, board startup, serial output, UEFI variables, peripheral
initialization, Secure Boot enforcement, recovery, or OS boot. Those require
hardware testing; build success is not evidence that they work.

Start with the [build instructions](README.md#build), then follow the
[hardware validation checklist](README.md#hardware-validation-still-required).
