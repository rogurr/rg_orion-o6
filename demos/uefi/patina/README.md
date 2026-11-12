# Patina DXE Core Integration Demo

This demonstration walks through the minimal changes required to replacing the EDK II C DXE core with an ODP-derived Rust Patina core in a default Radxa provided UEFI. It does this by walking through a normal clone/build of the repo, applying a patch to modify the files directly in the Radxa repo, then provides documentation on what changed. Due to patches being very specific to a file revision, the Radxa repository is expected to be pinned to a known release version, so the top of that tree is not guaranteed to work in this demonstration.

**Note:** The specific examples below assume this README.md is part of a clone in directory `~/odp-platform-radxa-orion-o6` and the Radxa repo cloning directory will be `~/edk2-cix`.  Paths in the commands below will need to be updated if different directories are used.

## Setup

1) Follow the Radxa Document Center's [BIOS Development](https://docs.radxa.com/en/orion/o6/low-level-dev/build-system/bios) guide to setup a new repository and compile.  During the [Download EDKII Source Code](https://docs.radxa.com/en/orion/o6/low-level-dev/build-system/bios#download-edk-ii-source-code) section, add `--branch 1.3.2` to the clone command to sync to tag 1.3.2.

   ```bash
   git clone --branch 1.3.2 --recurse-submodules https://github.com/radxa-pkg/edk2-cix.git
   ```

2) Rust is required to compile the Patina DXE core driver which can be downloaded by following the get started link from the [Rust Language](https://rust-lang.org/) web page.  The Patina code has a toolchain file that Rust will use to install the proper toolchain at compilation time, so this step only needs rustup installed per the web page.

3) Copy this entire demonstration folder to the root of the newly cloned edk2-cix repository and apply the changes.

   ```bash
   cd "~/edk2-cix/"
   cp -r "~/odp-platform-radxa-orion-o6/demos/uefi/patina/" "patina/"
   git apply "patina/Patina_Radxa_1.3.2.patch"
   ```

   After applying the patch, a Git diff command will show the modifications.
   
## Compiling

   The Patina team has made the decision to compile the Rust code idependently from UEFI then use the .fdf to pull the .efi into the build process, so this demonstration will be performing the same process.  The Patina [Platform Integration and Crate Patching](https://opendevicepartnership.github.io/patina/integrate/platform_integration_and_patching.html) documentation covers the background on this decision.

   To start, the rust code needs to be compiled.  The setup steps has placed a `./patina` folder in the edk2-cix repository, so the following steps assume you are in the environment to compile the Radxa codebase and the Rust language has been installed.

   ```bash
   cd "~/edk2-cix/patina/dxe_core"
   cargo build
   ```

   This will leave the 
   
   
    and compiling the repository normally will produce a UEFI that boots Patina.

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
