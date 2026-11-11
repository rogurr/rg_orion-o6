# Patina DXE core integration demo for Orion O6

See the [executive summary](ORION-O6-PATINA-EXECUTIVE-SUMMARY.md) for scope and
validation status. **This integration has not been boot-tested on hardware.**

## Sources and baseline

The Radxa-specific adaptations come from
[OpenDevicePartnership/odp-platform-radxa-orion-o6 at
3ab674fe9e8e095746d09cde3ee15f2cf94f1087](https://github.com/OpenDevicePartnership/odp-platform-radxa-orion-o6/tree/3ab674fe9e8e095746d09cde3ee15f2cf94f1087/bootchain/modules/uefi/platform):
the Patina platform driver, platform memory map, NOR-flash override, and
APRIORI replacement. The Rust wrapper is adapted under the accompanying
[MIT license](LICENSE). Existing CIX/EDK II files retain their original
BSD-2-Clause-Patent notices.

The Qualcomm Glymur example was inspected from the locally supplied original
and modified files. It supplied the presentation/organization pattern, not
Radxa platform patches. No Qualcomm source, UART implementation, BSP fixes, or
size study is included here.

The tested source baseline is:

| Repository | Commit |
| --- | --- |
| edk2-cix | `3711354` |
| src/edk2 | `39c4bb1d67e842b64cfab75a674b9620c2c45acd` |
| src/edk2-platforms | `352108383b2ceb3f88673f2f60a550ac35db181d` |
| src/edk2-non-osi | `4e99786e4caaf531bb9b04f097a018917463ae81` |

[Cargo.toml](Cargo.toml) pins the three direct Patina crates to `21.0.3`,
the version declared by the ODP reference.
[Cargo.lock](Cargo.lock) pins the resolved transitive dependencies as well;
some supporting Patina crates resolve to `21.2.0`.
[rust-toolchain.toml](rust-toolchain.toml) retains ODP's
`nightly-2025-09-19` toolchain. This is not a Patina upgrade to the version
used by the Qualcomm example.

## Build

Use the dependencies/environment from
[Radxa's BIOS development guide](https://docs.radxa.com/en/orion/o6/low-level-dev/build-system/bios).
Initialize the pinned submodules on a fresh checkout:

```sh
git submodule update --init --recursive
```

Also install [Rustup](https://rustup.rs/) if it is not already available.
Cargo uses the toolchain file in this directory. To install it explicitly:

```sh
rustup toolchain install nightly-2025-09-19 \
  --component rust-src --component rustfmt --component clippy \
  --target aarch64-unknown-uefi
```

From the repository root:

```sh
cd patina_dxe_core
./patch.sh
cargo build
cd ..
make deb
```

The [patch script](patch.sh) applies the
[platform patch](patches/edk2-platforms.patch), or reports that it is already
applied. Conflicts fail rather than overwrite local edits. It also writes
the two-byte `TRUE; END` dependency expression to `target/True.depex`.
The script works from any directory; from the workspace root its invocation
is `./patina_dxe_core/patch.sh`. After `cargo clean`, run the script again
before rebuilding firmware.

Plain `cargo build` uses the pinned toolchain and the target configured in
[.cargo/config.toml](.cargo/config.toml). Its normal output is
`target/aarch64-unknown-uefi/debug/dxe_core.efi`; no target-directory override
or release flag is required. The dev profile enables size optimization,
LTO, and one codegen unit to fit the existing UEFI flash region. INFO logging
and debug symbols remain enabled. The unused Brotli extractor is omitted.
No flash-layout change or firmware-feature reduction is used.

This is a **Patina-only O6 demonstration**. There is no core-selection switch
or C-core comparison target. The Radxa build defaults to RELEASE C drivers;
DEBUG/RELEASE do not select a different DXE core.

For firmware and full/OTA images without creating a Debian package, run
`make` from the workspace root. To use DEBUG C drivers, run
`make UEFI_TARGET=DEBUG`. Both use the same Rust binary produced by the
preceding `cargo build`. Firmware builds neither apply the patch nor invoke
Cargo: rerun `cargo build` after changing Rust code.

Rust formatting and Clippy can be checked separately from this directory:

```sh
cargo fmt -- --check
cargo clippy --locked -- -D warnings
```

The default cross-compiler prefix is `aarch64-linux-gnu-` on x86-64, or empty
on an AArch64 host. Override `GCC5_AARCH64_PREFIX` if necessary. Validation
here used the repository's CIX-verified GCC 10.2.1 download on x86-64:

```sh
make src/tools/gcc/gcc-arm-10.2-2020.11-x86_64-aarch64-none-elf
make GCC5_AARCH64_PREFIX="$PWD/src/tools/gcc/gcc-arm-10.2-2020.11-x86_64-aarch64-none-elf/bin/aarch64-none-elf-"
```

The [source makefile](../src/Makefile) uses the vendor EDK II compilation and
CIX packaging recipes in the existing [src workspace](../src/), with the
stock memory/PM configurations and firmware inputs. The FDF files reference
the Rust binary and TRUE-dependency file directly, relative to that workspace;
no Patina path definitions or private Conf directory are needed. Firmware
compilation checks for both inputs and runs EDK II on each invocation, while
EDK II retains its incremental module builds. Run build variants sequentially:
BaseTools and board configuration generators share the underlying source tree.

The TRUE-dependency paths use the standard `$(WORKSPACE)/../` anchor because
binary packaging rules otherwise resolve them relative to each module's output
directory, not the workspace. The Rust-core section uses a direct `../` path.

The normal `make deb` flow packages the resulting Patina firmware. Its
[install manifest](../debian/edk2-cix.install) includes O6 only; O6N is outside
this demonstration because the shared CIX integration is now unconditional.
Full Debian package creation has not been validated here: `make deb` stopped
because this host lacks `debuild` from `devscripts`. Workspace-root `make`
successfully built firmware and full/OTA images for DEBUG and RELEASE.

### Outputs

For the default RELEASE C-driver build:

| Output | Location |
| --- | --- |
| Rust core | `patina_dxe_core/target/aarch64-unknown-uefi/debug/dxe_core.efi` |
| Early-driver dependency input | `patina_dxe_core/target/True.depex` |
| UEFI image | `src/Build/O6/RELEASE_GCC5/FV/SKY1_BL33_UEFI.fd` |
| Full 8 MiB SPI image | `src/Build/O6/RELEASE_GCC5/cix_flash_all.bin` |
| OTA image | `src/Build/O6/RELEASE_GCC5/cix_flash_ota.bin` |

Paths in this table are relative to the repository root. DEBUG firmware
uses `src/Build/O6/DEBUG_GCC5/`; both configurations use the same optimized
dev-profile Rust core. Generated files, including packaging signing inputs, remain
under ignored build directories.
The existing vendor development signing setup is unchanged; do not treat it
as a production signing configuration.

## Existing source changes

The integration is unconditional. No command-line build flag or C compiler
define selects between Patina and the original core. The six vendor-file
edits remain annotated and are preserved in the submodule patch.

| Existing file | Change and reason |
| --- | --- |
| [Sky1Common.dsc.inc](../src/edk2-platforms/Platform/CIX/Sky1/Sky1Common.dsc.inc) | Omit C DXE core/CPU/GIC components. Other component bindings remain stock. |
| [O6.fdf](../src/edk2-platforms/Platform/Radxa/Orion/O6/O6.fdf) | Replace APRIORI with ordered early files and inline TRUE-dependency packaging rules. Read the dependency input prepared by the patch script. |
| [CIX Sky1Common.fdf.inc](../src/edk2-platforms/Platform/CIX/Sky1/Sky1Common.fdf.inc) | Package the normal Cargo output using a direct relative path instead of the C core; omit CPU/GIC and the normal copies of early files so no duplicate files are emitted. |
| [Radxa Sky1Common.fdf.inc](../src/edk2-platforms/Platform/Radxa/Platforms/CIX/Sky1/Sky1Common.fdf.inc) | Suppress the second copy of the early platform setup-variable driver. |
| [ArmPlatformLibMem.c](../src/edk2-platforms/Platform/CIX/Sky1/Library/PlatformLib/ArmPlatformLibMem.c) | Keep the original memory-map function, but emit v2 resource HOBs with WC for secure/shared/framebuffer memory, WB for ordinary RAM/FD, and UC for MMIO. Add both MMIO apertures and skip the NULL page as in ODP. The framebuffer also needs a WC capability. The original allocation HOBs are unchanged. |
| [NorFlashStmmRuntimeDxe.c](../src/edk2-platforms/Silicon/CIX/Sky1/Drivers/NorFlashStmmRuntimeDxe/NorFlashStmmRuntimeDxe.c) | Use the ODP 8 MiB NOR extent and skip `AddMemorySpace` for the range already described by the MMIO HOB; retain runtime-attribute setup. |
| [src/Makefile](../src/Makefile) | Build O6 only using the vendor compilation and packaging recipes. Require the separately prepared Rust binary and dependency input, and invoke EDK II even when an FD already exists. |
| [edk2-cix.install](../debian/edk2-cix.install) | Install only the generated O6 images, not unsupported O6N outputs. |

The core's FFS GUID is `23C9322F-2AF2-476A-BC4C-26BC88266C71`, as in ODP.
The [existing PrePi](../src/edk2-platforms/Platform/CIX/Sky1/PrePi/PrePi.c)
decompresses the child FV and calls `LoadDxeCoreFromFv`; no new loader is
needed. The [Rust entry point](src/main.rs) takes the physical HOB-list
pointer, initializes the logger, and calls `Core::entry_point`.

The O6 UART and GIC bases are taken from ODP and match the stock DSC:
UART `0x040D0000`, GIC distributor `0x0E010000`, redistributors `0x0E090000`.

The APRIORI replacement deliberately follows the ODP workaround. Only the
17 early drivers get the `TRUE; END` expression (`06 08`); all other
dependency expressions remain unchanged. Resolving their real dependencies
instead is a separate driver-maintenance effort.

The ODP graphics binary override, removal of CIX's debug-mode initialization,
and broader DSC/FDF/bootchain changes are not imported. They are not required
to build this integration, and their runtime necessity for this different
vendor baseline has not been established.

### Persistence and reversal

The six modifications live inside a Git submodule. The parent repository
cannot retain those dirty files by itself; therefore the complete
[patch](patches/edk2-platforms.patch) is included and `patch.sh` applies it.
This checkout already has it applied. No submodule commit or gitlink update
is needed to distribute the integration with the parent build changes.

To undo just these source edits, from the repository root:

```sh
git -C src/edk2-platforms apply --reverse --check ../../patina_dxe_core/patches/edk2-platforms.patch
git -C src/edk2-platforms apply --reverse ../../patina_dxe_core/patches/edk2-platforms.patch
```

Do not use a reset to remove the patch; preserve unrelated local edits.
Running `patch.sh` again reapplies it; a normal firmware build does not.
**Reversing the submodule patch alone does not restore a stock build.**
To return to vendor firmware, revert the complete integration with Git,
including the parent build/install changes, or use a separate clean upstream
clone. There is intentionally no build option for the original core.

## Hardware validation still required

Build and binary-inspection results are recorded in the
[executive summary](ORION-O6-PATINA-EXECUTIVE-SUMMARY.md#validation-completed).
No board was attached during implementation. This sample targets the
stock O6 SPI-variable/StandaloneMM configuration only, not O6N or arbitrary
DSC feature combinations.

1. Retain a known-good firmware backup and a working offline recovery method.
   Follow [Radxa's BIOS documentation](https://docs.radxa.com/en/orion/o6/low-level-dev/build-system/bios)
   and [SPI flashing guidance](https://docs.radxa.com/en/orion/o6/low-level-dev/bios#flash-bios-firmware-using-a-programmer-only-when-system-cannot-boot).
   No flashing or device access is performed by the patch script or build commands.
2. Test the DEBUG full image on a recoverable O6 and capture the debug UART
   at 115200 baud. [Unverified] The expected first Rust marker is
   `[Patina INFO] DXE Core Platform Binary Entry`; observing it demonstrates
   entry into the wrapper, not successful driver dispatch or OS boot.
3. Check subsequent driver dispatch and the UEFI boot manager/shell. Test
   variable persistence across a cold boot, NVMe/USB/display, and the
   intended OS. Test Secure Boot enforcement separately if it is required.
4. Compare with known-good vendor firmware from a separate upstream checkout.
   Save the UART log and first failure before changing additional drivers.

Successful compilation and packaging cannot establish any of these hardware
results. The APRIORI workaround and compatibility mode remain demonstration
limitations even after an initial successful boot.
