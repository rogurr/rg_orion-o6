# Patina DXE Core Integration Demo

This demonstration walks through the minimal changes required to replace the EDK II C DXE core with an ODP-derived Rust Patina core in Radxa's default UEFI firmware. It covers cloning and building the repository, building the Patina driver, applying a patch directly to the Radxa source files, and reviewing the changes. Because patches depend on specific file revisions, this demonstration pins the Radxa repository to a known release version. The latest revision may not work with this demonstration.

**Note:** The examples below assume this repository is cloned into `~/odp-platform-radxa-orion-o6` and the Radxa repository is cloned into `~/edk2-cix`. Update the paths in the commands below if you use different directories.

## Building UEFI Firmware with Patina

This demonstration compiles the Patina DXE core independently of the UEFI firmware and includes it in the firmware volume through the FDF file. The Patina [Platform Integration and Crate Patching](https://opendevicepartnership.github.io/patina/integrate/platform_integration_and_patching.html) documentation covers the background on this approach.

1) Follow the Radxa Document Center's [BIOS Development](https://docs.radxa.com/en/orion/o6/low-level-dev/build-system/bios) guide to set up a new repository. During the GitHub download step, add `--branch 1.3.2` to the clone command to check out release tag `1.3.2`.

   ```bash
   git clone --branch 1.3.2 --recurse-submodules https://github.com/radxa-pkg/edk2-cix.git
   ```

   Compiling the unmodified firmware at least once is recommended to establish a baseline. Remove generated build outputs before proceeding.

2) Rust is required to compile the Patina DXE core and can be installed by following the getting started instructions on the [Rust Language](https://rust-lang.org/) website. Since the Patina DXE core is compiled independently, the toolchain can be installed either in the CIX build environment or in the host PC environment.

   Once Rust is installed, change to the `dxe_core` directory, run the Rust build, and copy the resulting EFI binary to the `edk2-cix` repository root for the firmware build to use. By default, Cargo places build outputs in a local `target` directory.

   ```bash
   cd ~/odp-platform-radxa-orion-o6/demos/uefi/patina/dxe_core
   cargo build
   cp target/aarch64-unknown-uefi/debug/dxe_core.efi ~/edk2-cix/dxe_core.efi
   ```

3) Patch the `edk2-platforms` submodule in the newly cloned `edk2-cix` repository with modifications needed by Patina.

   ```bash
   cd ~/edk2-cix/src/edk2-platforms
   git apply ~/odp-platform-radxa-orion-o6/demos/uefi/patina/edk2-platforms_1.3.2.patch
   ```

4) Repeat the build process from step 1 to include the Patina DXE core in the Orion O6 build process.

## Change Walkthrough







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
