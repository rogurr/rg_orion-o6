#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PLATFORMS_DIR="$SCRIPT_DIR/../src/edk2-platforms"
PATCH="$SCRIPT_DIR/patches/edk2-platforms.patch"

if [[ ! -e "$PLATFORMS_DIR/.git" ]]; then
    echo "Initialize the submodules with git submodule update --init --recursive from the workspace root." >&2
    exit 1
fi

if git -C "$PLATFORMS_DIR" apply --reverse --check "$PATCH" 2>/dev/null; then
    echo "Patina platform patch already applied."
else
    git -C "$PLATFORMS_DIR" apply --check "$PATCH"
    git -C "$PLATFORMS_DIR" apply "$PATCH"
    echo "Applied Patina platform patch."
fi

mkdir -p -- "$SCRIPT_DIR/target"
printf '\006\010' > "$SCRIPT_DIR/target/True.depex"
echo "Prepared target/True.depex for the early-driver packaging rules."
