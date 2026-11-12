# Patina DXE Core Integration Demo

This demonstration walks through the minimal changes required to replace the EDK II C DXE core with an ODP-derived Rust Patina core in Radxa's default UEFI firmware. It covers cloning and building the repository, building the Patina driver, applying a patch directly to the Radxa source files, and reviewing the changes. Because patches depend on specific file revisions, this demonstration pins the Radxa repository to a known release version. The latest revision may not work with this demonstration.

**Note:** The examples below assume this repository is cloned into `~/odp-platform-radxa-orion-o6` and the Radxa repository is cloned into `~/edk2-cix`. Update the paths in the commands below if you use different directories.

## Baseline Codebase

Clone and build the Orion O6 UEFI by following the Radxa Document Center's [BIOS Development](https://docs.radxa.com/en/orion/o6/low-level-dev/build-system/bios) guide. During the GitHub download step, add `--branch 1.3.2` to the clone command to check out release tag `1.3.2`.

   ```bash
   git clone --branch 1.3.2 --recurse-submodules https://github.com/radxa-pkg/edk2-cix.git
   ```

Compiling the unmodified firmware at least once is recommended to establish a baseline. Remove generated build outputs before proceeding.

## Building the Patina DXE Core Driver

This demonstration compiles the Patina DXE core independently of the UEFI then includes it in the firmware volume through the FDF file. The Patina [Platform Integration and Crate Patching](https://opendevicepartnership.github.io/patina/integrate/platform_integration_and_patching.html) documentation covers the background on this approach.

Rust is required to compile the Patina DXE core and can be installed by following the getting started instructions on the [Rust Language](https://rust-lang.org/) website. Since the Patina DXE core is compiled independently, the toolchain can be installed either in the CIX build environment or in the host PC environment.

Once Rust is installed, change to the `dxe_core` directory, run the Rust build, and copy the resulting EFI binary to the `edk2-cix` repository root for the firmware build to use. By default, Cargo places build outputs in a local `target` directory.

   ```bash
   cd ~/odp-platform-radxa-orion-o6/demos/uefi/patina/dxe_core
   cargo build
   cp target/aarch64-unknown-uefi/debug/dxe_core.efi ~/edk2-cix/dxe_core.efi
   ```

## Patch the edm2-Platforms Submodule

Make the necessary Patina support changes to the original code by patching the `edk2-platforms` submodule.  The provided Git .patch file contains all changes necessary.

   ```bash
   cd ~/edk2-cix/src/edk2-platforms
   git apply ~/odp-platform-radxa-orion-o6/demos/uefi/patina/edk2-platforms_1.3.2.patch
   ```

## Rebuild with Patina

Repeat the build process from step 1 to include the Patina DXE core in the Orion O6 build process.  For details of each change and why it is present, please perform a diff of the repository and all submodules to see what files changed, then a compare of the base file to the changes will highlight the code modifications plus new comments describing why the change is present.
