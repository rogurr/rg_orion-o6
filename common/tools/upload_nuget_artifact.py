#!/usr/bin/env python3
#
# Helper to publish build outputs to a GitHub Packages NuGet feed.
#
# SPDX-License-Identifier: MIT
#
# The packages will use a version based on the date in Y.M.D form (e.g. 2026.5.12) without leading zeros due to NuGet
# restrictions. If a package with a version already exists, `.(n)` is appended where (n) is the count of existing
# same-day versions.
#
#   first published today  -> 2026.5.12
#   second published today -> 2026.5.12.1
#   third published today  -> 2026.5.12.2
#
# Usage:
#   python3 upload_nuget_artifact.py \
#     --package-id <NuGet.Package.Id> \
#     --description "<one-line description>" \
#     --input_dir "<absolute path to directory of files to package>" \
#     --output_dir "<absolute path to directory where .nupkg will be written>"
#

import argparse
import os
import re
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

# ----- Argument parsing ----------------------------------------------------------------------------------------------

parser = argparse.ArgumentParser(
    description="Publish build outputs to a GitHub Packages NuGet feed."
)
parser.add_argument("--package-id", required=True)
parser.add_argument("--description", required=True)
parser.add_argument("--input_dir", required=True)
parser.add_argument("--output_dir", required=True)
args = parser.parse_args()

gh_token = os.environ.get("GH_TOKEN", "")
if not gh_token:
    print("GH_TOKEN environment variable is required", file=sys.stderr)
    sys.exit(2)

if not os.path.isdir(args.input_dir):
    print(f"input directory not found: {args.input_dir}", file=sys.stderr)
    sys.exit(2)

# ----- Version string ------------------------------------------------------------------------------------------------

# Date in NuGet-friendly form (no leading zeros on month or day).
now = datetime.now(timezone.utc)
base = f"{now.year}.{now.month}.{now.day}"

# Get number of existing versions
# TODO: rogurr namespace. Revert to opendevicepartnership before merging to upstream.
existing = ""
try:
    existing = subprocess.check_output(
        [
            "gh", "api",
            "-H", "Accept: application/vnd.github+json",
            f"/users/rogurr/packages/nuget/{args.package_id}/versions",
            "--jq", ".[].name",
        ],
        stderr=subprocess.DEVNULL,
        text=True,
    )
except (subprocess.CalledProcessError, FileNotFoundError):
    pass

pattern = re.compile(rf"^{re.escape(base)}(\.\d+)?$")
count = sum(1 for line in existing.splitlines() if line and pattern.match(line))

# Append count suffix if a version with today's date already exists.
version = base if count == 0 else f"{base}.{count}"

# ----- Create package ------------------------------------------------------------------------------------------------

os.makedirs(args.output_dir, exist_ok=True)

script_dir = Path(__file__).resolve().parent

subprocess.check_call(
    [
        "dotnet", "pack", str(script_dir / "nuget_release_project.csproj"),
        f"-p:PackageId={args.package_id}",
        f"-p:Version={version}",
        f"-p:Description={args.description}",
        f"-p:PayloadPath={args.input_dir}",
        "-o", args.output_dir,
    ],
    stderr=sys.stderr,
    stdout=sys.stderr,
)

# ----- Push package to NuGet feed ------------------------------------------------------------------------------------

# TODO: rogurr namespace. Revert source to opendevicepartnership before merging to upstream.
subprocess.check_call(
    [
        "dotnet", "nuget", "push", f"{args.output_dir}/{args.package_id}.{version}.nupkg",
        "--source", "https://nuget.pkg.github.com/rogurr/index.json",
        "--api-key", gh_token,
        "--skip-duplicate",
    ],
    stderr=sys.stderr,
    stdout=sys.stderr,
)

# ----- Output Status -------------------------------------------------------------------------------------------------

print(
    f"Nuget package published successfully:\n"
    f"  Package ID:  {args.package_id}\n"
    f"  Version:     {version}\n"
    f"  Description: {args.description}\n"
    f"  Input Dir:   {args.input_dir}\n"
    f"  Output Dir:  {args.output_dir}",
    file=sys.stderr,
)
