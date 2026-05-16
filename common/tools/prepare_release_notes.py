#!/usr/bin/env python3
#
# SPDX-License-Identifier: MIT
#
# Prepares release notes for a Radxa Orion O6 platform release
#

import argparse
from pathlib import Path

def main() -> None:
    parser = argparse.ArgumentParser(
        description="Prepare release notes for a GitHub Release."
    )
    parser.add_argument("--git-tag", required=True, help="Git tag for this release (vYYYY.MM.DD)")
    parser.add_argument("--notes-file", default="release-notes.md", help="Path to output release notes file")
    args = parser.parse_args()

    # TBD: Need to expand on information
    notes = "\n".join([
        f"# ODP Orion O6 Release - {args.git_tag}",
        "",
        "Release notes format - TBD",
        "",
    ])
    Path(args.notes_file).write_text(notes)

if __name__ == "__main__":
    main()
