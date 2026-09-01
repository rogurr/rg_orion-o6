#!/usr/bin/env bash
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATCH="$HERE/edk2-working-tree.patch"
TARGET="$HERE/../edk2"

git -C "$TARGET" apply --check --verbose "$PATCH"
git -C "$TARGET" apply --verbose "$PATCH"
echo "override applied to $TARGET"
