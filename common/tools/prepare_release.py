#!/usr/bin/env python3
#
# Generates release notes for a GitHub Release of the Radxa Orion O6 platform.
#
# Scans a directory of .nupkg files to build the manifest table and writes
# a Markdown file suitable for `gh release create --notes-file`.
#
# Usage:
#   python3 prepare_release.py \
#     --git-ref <tag>                        \
#     --container <full GHCR image:tag>      \
#     --nuget-dir <path with .nupkg files>   \
#     --output <release-notes.md>
#
# SPDX-License-Identifier: MIT
#

import argparse
import re
import sys
from pathlib import Path

# Main entry point
#
def main() -> None:
    parser = argparse.ArgumentParser(
        description="Generate release notes for a GitHub Release."
    )
    parser.add_argument("--git-ref", required=True, help="Git tag for this release")
    parser.add_argument("--nuget-dir", required=True, help="Directory containing .nupkg files")
    parser.add_argument("--output", required=True, help="Path to write release notes Markdown")
    args = parser.parse_args()

    nuget_dir = Path(args.nuget_dir)
    if not nuget_dir.is_dir():
        print(f"NuGet directory not found: {nuget_dir}", file=sys.stderr)
        sys.exit(1)

    versions: dict[str, str] = {}
    for nupkg in sorted(nuget_dir.glob("*.nupkg")):
        # Match: <PackageId>.<Version>.nupkg where version starts with a digit
        match = re.match(r"^(.+?)\.(\d+\..+)\.nupkg$", nupkg.name)
        if match:
            versions[match.group(1)] = match.group(2)

    rows = []
    for pkg_id, version in sorted(versions.items()):
        rows.append(f"| `{pkg_id}` | `{version}` |")
    nupkg_table = "\n".join(rows) if rows else "| _(none)_ | |"

    notes = "\n".join([
        f"# Release: {args.git_ref}",
        "",
        f"Release of the Radxa Orion O6 platform deliverables built from `{args.git_ref}`.",
        "",
        "## NuGet Packages",
        "",
        "| Package | Version |",
        "|---|---|",
        f"{nupkg_table}",
        "",
        "## Downloading the binaries",
        "",
        "The binary artifacts are attached as release assets below and are also available",
        "as independently versioned NuGet packages on the repository's Packages tab.",
        "",
    ])

    output_path = Path(args.output)
    output_path.write_text(notes)
    print(f"Release notes written to {output_path}", file=sys.stderr)

if __name__ == "__main__":
    main()
