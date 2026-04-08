#!/usr/bin/env nix
#!nix shell --ignore-environment nixpkgs#bash nixpkgs#cacert nixpkgs#coreutils nixpkgs#gnugrep nixpkgs#gnused nixpkgs#curl nixpkgs#nodejs nixpkgs#nix --command bash

set -euo pipefail

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
DEFAULT_NIX="$SCRIPT_DIR/default.nix"

echo "Fetching latest @github/copilot from npm registry..."
LATEST_VERSION=$(npm view @github/copilot version)
tarball="https://registry.npmjs.org/@github/copilot/-/copilot-${LATEST_VERSION}.tgz"

CURRENT_VERSION=$(grep -E '^\s*version\s*=' "$DEFAULT_NIX" | sed -E 's/.*version\s*=\s*"([^"]+)".*/\1/')

echo "Current version: $CURRENT_VERSION"
echo "Latest version:  $LATEST_VERSION"

if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
  echo "✓ copilot-cli is already up to date (version $CURRENT_VERSION)"
  exit 0
fi

echo "Computing hash for $tarball ..."
hash=$(nix-prefetch-url --type sha256 "$tarball" 2>/dev/null)
sri_hash=$(nix hash convert --hash-algo sha256 "$hash")

if [ -z "$sri_hash" ]; then
  echo "Error: Failed to compute hash" >&2
  exit 1
fi

echo "New hash: $sri_hash"
echo "Updating default.nix: $CURRENT_VERSION -> $LATEST_VERSION"

sed -i "s/version = \"[^\"]*\";/version = \"$LATEST_VERSION\";/" "$DEFAULT_NIX"
sed -i "s|hash = \"sha256-[^\"]*\";|hash = \"$sri_hash\";|" "$DEFAULT_NIX"

echo "✓ Successfully updated copilot-cli to version $LATEST_VERSION"
