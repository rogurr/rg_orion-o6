<!-- SPDX-License-Identifier: MIT -->

# Tribal Knowledge

Prioritized ownership-handoff checklist based on repository source and documentation. No firmware build, hardware boot, timing measurements, or GitHub permission checks were performed.

## P0 - Establish the condensed build/boot baseline

- Define "condensed" with clean/no-op build times, power-on-to-OS time, and compiled/packaged driver counts; distinguish payload size from the [SPI layout](./common/spi_flash_config_all.json).
- Freeze a known-good baseline tag with matching firmware, WIM, configuration, and boot log; use it as the starting point for feature-demo branches.
- Create a non-Patina baseline: the [UEFI build](./bootchain/modules/uefi/Makefile) and [DXE-core packaging](./bootchain/modules/uefi/platform/OVERRIDE/Platform/CIX/Sky1/Sky1Common.fdf.inc) currently select Patina unconditionally.
- Reduce the [DSC](./bootchain/modules/uefi/platform/O6.dsc) and [FDF](./bootchain/modules/uefi/platform/O6.fdf) to one justified feature set; review graphics, USB, network, capsule, and TPM components rather than retaining unexplained alternatives.
- Align compiled DSC components with packaged FDF components so unused drivers do not inflate the baseline build.
- Document the complete boot/artifact chain, including vendor bootloader1, EC firmware, TF-A, OP-TEE, StandaloneMM, and UEFI; distinguish [copied binaries from source-built outputs](./bootchain/Makefile).
- Either package the [secure-services outputs](./bootchain/modules/secure-services/Makefile) or leave their build out of the minimal demo; current [stitching](./bootchain/Makefile) does not reference either output.

## P0 - Demonstrate adding Patina as an isolated change

- Publish a short, replayable baseline-to-Patina commit sequence with build commands, expected differences, and a rollback point.
- Explain the [Patina entry point](./bootchain/modules/uefi/platform/Drivers/PatinaDxeCore_ru/src/main.rs), incoming HOB list, section extractor, and UART/GIC configuration.
- Document and test the [resource-descriptor HOB v2 contract](./bootchain/modules/uefi/platform/Library/PlatformLib/ArmPlatformLibMem.c), including RAM/MMIO coverage, reserved regions, memory attributes, and overlap checks.
- Explain why the [Patina FDF integration](./bootchain/modules/uefi/platform/O6.fdf) removes EDK II CpuDxe and ArmGicDxe, and what supplies those services afterward.
- Document the [TRUE-DEPEX/FV-order workaround](./bootchain/modules/uefi/platform/O6.fdf), its dependency assumptions, and the checks required whenever driver ordering changes.
- Record the rationale, upstream delta, and removal criteria for the [NorFlash override](./bootchain/modules/uefi/platform/OVERRIDE/Silicon/CIX/Sky1/Drivers/NorFlashStmmRuntimeDxe/) and the source/version/rebuild recipe for the replacement [LCD binary](./bootchain/modules/uefi/platform/OVERRIDE/Silicon/CIX/Sky1/Drivers/LcdGraphicsOutputDxe/).
- Explain why [compatibility mode is enabled by default](./bootchain/modules/uefi/platform/Drivers/PatinaDxeCore_ru/Cargo.toml), which behavior depends on it, and how to validate changing it.
- Capture baseline-versus-Patina results using the same board, WIM, peripherals, and initial variable state; cover debug/release boot, restart, shutdown, variable persistence, and the intended Secure Boot behavior.

## P1 - Correct documentation that can mislead the next engineer

- Correct the module READMEs' standalone `make` examples: [child makefiles require parent-exported variables](./bootchain/modules/uefi/Makefile); provide supported module-rebuild entry points that also handle prerequisites.
- Reconcile the [root quick start's Windows-desktop endpoint](./README.md) with the [Validation OS guide's no-desktop image](./os_image/README.md); show the actual expected successful boot screen or prompt.
- Replace the [hard-coded WIM index 3](./os_image/README.md) with instructions to inspect `dism /Get-WimInfo` and choose the correct index for each supported image.
- Correct the [Common README's root-Makefile reference](./common/README.md) and the [Patina constants' obsolete source path](./bootchain/modules/uefi/platform/Drivers/PatinaDxeCore_ru/src/lib.rs).
- Rewrite the [secure-services README](./bootchain/modules/secure-services/README.md): it describes QEMU, nonexistent local paths, and Hafnium integration, while the [current TF-A build selects OP-TEE](./bootchain/modules/tf-a/Makefile).

## P1 - Make builds, upgrades, and validation reproducible

- Stop ignoring application `Cargo.lock` files in [.gitignore](./.gitignore); commit tested dependency resolutions and use locked builds for released binaries.
- Pin the remaining floating Rust/tool dependencies used by [secure-services](./bootchain/modules/secure-services/Makefile) and tests; record the tested GCC/Rust/Patina combination.
- Document submodule upgrades as one procedure covering [.gitmodules](./.gitmodules), expected commits in [patch scripts](./bootchain/OVERRIDE/), patch rebasing, platform overrides, and hardware revalidation.
- Replace the [UEFI build's in-place thermal-ASL edits](./bootchain/modules/uefi/Makefile) with explicit build configuration or tracked patches; avoid cleanup that discards a developer's submodule edits.
- Make incremental rebuilds meaningful: [memory](./bootchain/modules/mem_config/Makefile) and [power](./bootchain/modules/pm_config/Makefile) configuration builds currently delete and recopy their sources on every invocation.
- Add a release manifest with parent/submodule SHAs, applied patches, tool versions, container digest, and artifact hashes; document timestamp-dependent output in the [UEFI build](./bootchain/modules/uefi/Makefile).
- Record the downloaded [Validation OS ISO's](./.github/workflows/build_os_image.yml) build number and checksum, plus acquisition/distribution requirements, rather than relying only on a moving download URL.
- Document container updates across the [local image-version label](./.devcontainer/Dockerfile) and [CI image references](./.github/workflows/); distinguish supported host architectures and CIX-tool emulation requirements.
- Expand [test coverage](./bootchain/Makefile) beyond Patina helper tests and ASL-source checks: exercise release-only tests, generated AML, packaged-file presence, and flash-region size/overlap limits.

## P1 - Transfer the bench and release knowledge

- Record one supported board/RAM revision, NVMe, peripherals, firmware settings, and OS build; list known-good features and known limitations beside the [scope statement](./README.md).
- Add a per-stage UART table with header/pins, voltage, baud/framing, sample log markers, and last-good-stage troubleshooting; the [hardware guide](./bootchain/README.md) currently delegates stage specifics to module READMEs.
- Extend the [flashing guide](./bootchain/README.md) with the exact tested programmer/adapter setup, original-image backup, readback verification, and a rehearsed no-boot recovery procedure.
- Document variable-store preservation/reset, Secure Boot enrollment, and the distinct TF-A/OEM/UEFI trust inputs; explain the [demo signing keys and counter values](./bootchain/Makefile) without treating them as production provisioning.
- Write the release/container runbook: tag creation, publishing order, image-reference updates, approvals, failed-run recovery, and a backup maintainer with verified access to the [release workflows](./.github/workflows/) and [owner team](./CODEOWNERS).
- Declare the canonical repository and fork policy; reconcile [README links](./README.md), clone instructions, badges, and the [hard-coded GHCR publication namespace](./.github/workflows/publish_container.yml).
- Refresh [NOTICE](./NOTICE): its old directory paths need updating, and Patina, secure-services, and redistributed binary/tool attributions need an explicit inventory.
- Have the successor independently clone, build, provision, boot, recover, and publish using only repository instructions; turn every remaining private-note dependency into a documented step or tracked issue.

## P2 - Close secure-services loose ends before a later feature demo

- Reconcile the EC UART address: the [driver](./bootchain/modules/secure-services/platform/src/baremetal/uart.rs) uses `0x040E0000`, while the [partition manifest](./bootchain/modules/secure-services/platform/linker/orion-o6-ec-sp.dts) maps `0x040D0000`.
- Reconcile the [linker region's 2 MiB allowance](./bootchain/modules/secure-services/platform/linker/orion-o6.ld) with the [manifest's 0x50000 image size](./bootchain/modules/secure-services/platform/linker/orion-o6-ec-sp.dts); check entry offset, RX/TX reservations, and advertised service UUIDs together.
- Add bounded waits and absent-EC diagnostics to the [UART transport](./bootchain/modules/secure-services/platform/src/baremetal/uart.rs), whose reads and writes currently poll without timeouts.
