#!/usr/bin/env nix
#!nix shell --ignore-environment nixpkgs#bash nixpkgs#cacert nixpkgs#coreutils nixpkgs#curl nixpkgs#gawk nixpkgs#gnugrep nixpkgs#gnused nixpkgs#nix nixpkgs#python3 --command bash

set -euo pipefail

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
DEFAULT_NIX="$SCRIPT_DIR/default.nix"
RELEASES_API="https://api.github.com/repos/Kotlin/kotlin-lsp/releases/latest"

echo "Fetching latest version information..."

release_json=$(curl -fsSL "$RELEASES_API")

read -r latest_version latest_url < <(
  RELEASE_JSON="$release_json" python3 - <<'PY'
import json
import os
import re
import sys

release = json.loads(os.environ["RELEASE_JSON"])
tag = release["tag_name"].rsplit("/", 1)[-1]
version = tag.removeprefix("v")
body = release.get("body", "")

match = re.search(
    r"https://download-cdn\.jetbrains\.com/kotlin-lsp/[^)\s\"']+/kotlin-server-[^)\s\"']+\.tar\.gz",
    body,
)
if not match:
    print("Error: failed to find standalone Linux-x64 Kotlin LSP URL", file=sys.stderr)
    sys.exit(1)

print(version, match.group(0))
PY
)

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

echo "Computing hash for new version..."
raw_hash=$(nix-prefetch-url --type sha256 "$latest_url" 2>/dev/null)
hash=$(nix hash convert --hash-algo sha256 "$raw_hash")

if [ -z "$hash" ]; then
  echo "Error: Failed to compute hash" >&2
  exit 1
fi

echo "New hash: $hash"
echo "Updating default.nix..."

sed -i "s/version = \"$current_version\";/version = \"$latest_version\";/" "$DEFAULT_NIX"

awk -v new_url="$latest_url" '
  /^[[:space:]]*url[[:space:]]*=/ {
    sub(/"[^"]*"/, "\"" new_url "\"")
  }
  { print }
' "$DEFAULT_NIX" > "$DEFAULT_NIX.tmp" && mv "$DEFAULT_NIX.tmp" "$DEFAULT_NIX"

awk -v new_hash="$hash" '
  /^[[:space:]]*hash[[:space:]]*=/ {
    sub(/"[^"]*"/, "\"" new_hash "\"")
  }
  { print }
' "$DEFAULT_NIX" > "$DEFAULT_NIX.tmp" && mv "$DEFAULT_NIX.tmp" "$DEFAULT_NIX"

echo "Successfully updated to version $latest_version"
