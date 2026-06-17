#!/usr/bin/env nix
#!nix shell --ignore-environment nixpkgs#bash nixpkgs#cacert nixpkgs#coreutils nixpkgs#curl nixpkgs#gawk nixpkgs#gnugrep nixpkgs#gnused nixpkgs#nix nixpkgs#python3 --command bash

set -euo pipefail

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
DEFAULT_NIX="$SCRIPT_DIR/default.nix"
RELEASES_API="https://api.github.com/repos/Kotlin/kotlin-lsp/releases/latest"

echo "Fetching latest version information..."

release_json=$(curl -fsSL "$RELEASES_API")

updates_tsv=$(
  RELEASE_JSON="$release_json" python3 - <<'PY'
import json
import os
import re
import sys

release = json.loads(os.environ["RELEASE_JSON"])
tag = release["tag_name"].rsplit("/", 1)[-1]
version = tag.removeprefix("v")
body = release.get("body", "")

label_to_system = {
    "macOS-x64": "x86_64-darwin",
    "macOS-arm64": "aarch64-darwin",
    "Linux-x64": "x86_64-linux",
    "Linux-arm64": "aarch64-linux",
}

matches = re.findall(
    r"\[Download for ([^\]]+)\]\((https://download-cdn\.jetbrains\.com/kotlin-lsp/[^)\s\"']+/kotlin-server-[^)\s\"']+\.(?:tar\.gz|sit))\)"
    r".*?\[SHA-256 checksum\]\((https://download-cdn\.jetbrains\.com/kotlin-lsp/[^)\s\"']+\.sha256)\)",
    body,
)

by_system = {}
for label, url, checksum_url in matches:
    system = label_to_system.get(label)
    if system:
        by_system[system] = (url.rsplit("/", 1)[-1], checksum_url)

missing = sorted(set(label_to_system.values()) - set(by_system))
if missing:
    print(f"Error: failed to find standalone Kotlin LSP URLs for: {', '.join(missing)}", file=sys.stderr)
    sys.exit(1)

for system in ["x86_64-linux", "aarch64-linux", "x86_64-darwin", "aarch64-darwin"]:
    artifact, checksum_url = by_system[system]
    print(f"{version}\t{system}\t{artifact}\t{checksum_url}")
PY
)

latest_version=$(printf '%s\n' "$updates_tsv" | awk 'NR == 1 { print $1 }')

current_version=$(grep -E '^[[:space:]]*version[[:space:]]*=' "$DEFAULT_NIX" | sed -E 's/.*version[[:space:]]*=[[:space:]]*"([^"]+)";.*/\1/')

if [ -z "$current_version" ]; then
  echo "Error: Failed to extract current version from default.nix" >&2
  exit 1
fi

echo "Current version: $current_version"
echo "Latest version:  $latest_version"

if [ "$current_version" = "$latest_version" ]; then
  echo "Already up to date!"
  exit 0
fi

echo "Fetching official checksums..."
hash_updates=""
while IFS="$(printf '\t')" read -r version system artifact checksum_url; do
  checksum_line=$(curl -fsSL "$checksum_url")
  checksum_hex=$(printf '%s\n' "$checksum_line" | awk '{ print $1 }')
  hash=$(nix hash convert --hash-algo sha256 --to sri "$checksum_hex")

  if [ -z "$hash" ]; then
    echo "Error: Failed to compute hash for $system" >&2
    exit 1
  fi

  echo "  $system: $artifact $hash"
  hash_updates="${hash_updates}${system}	${artifact}	${hash}
"
done <<EOF
$updates_tsv
EOF

echo "Updating default.nix..."

LATEST_VERSION="$latest_version" HASH_UPDATES="$hash_updates" DEFAULT_NIX="$DEFAULT_NIX" python3 - <<'PY'
import os
import re
from pathlib import Path

path = Path(os.environ["DEFAULT_NIX"])
latest_version = os.environ["LATEST_VERSION"]

updates = {}
for line in os.environ["HASH_UPDATES"].splitlines():
    system, artifact, hash_value = line.split("\t")
    artifact = artifact.replace(latest_version, "${version}")
    updates[system] = (artifact, hash_value)

text = path.read_text()
text = re.sub(r'version = "[^"]+";', f'version = "{latest_version}";', text, count=1)

for system, (artifact, hash_value) in updates.items():
    block_pattern = re.compile(
        rf'({re.escape(system)} = \{{\n'
        rf'(?:[^\n]*\n)*?'
        rf'\s*artifact = ")[^"]+(";\n'
        rf'\s*hash = ")[^"]+(";\n'
        rf'\s*\}};)',
        re.MULTILINE,
    )

    def replace(match):
        block = match.group(0)
        block = re.sub(r'artifact = "[^"]+";', f'artifact = "{artifact}";', block)
        block = re.sub(r'hash = "[^"]+";', f'hash = "{hash_value}";', block)
        return block

    text, count = block_pattern.subn(replace, text, count=1)
    if count != 1:
        raise SystemExit(f"failed to update {system} block")

path.write_text(text)
PY

echo "Successfully updated to version $latest_version"
