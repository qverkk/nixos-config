#!/usr/bin/env nix
#!nix shell --ignore-environment nixpkgs#bash nixpkgs#cacert nixpkgs#coreutils nixpkgs#curl nixpkgs#gnugrep nixpkgs#gnused nixpkgs#nodejs nixpkgs#nix --command bash

set -euo pipefail

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
DEFAULT_NIX="$SCRIPT_DIR/default.nix"

echo "Fetching latest @openai/codex from npm registry..."

# Get the latest version from npm using npm view
LATEST_VERSION=$(npm view @openai/codex version)

CURRENT_VERSION=$(grep -E '^\s*version\s*=' "$DEFAULT_NIX" | sed -E 's/.*version\s*=\s*"([^"]+)".*/\1/')

echo "Current version: $CURRENT_VERSION"
echo "Latest version:  $LATEST_VERSION"

if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
  echo "✓ codex-cli is already up to date (version $CURRENT_VERSION)"
  exit 0
fi

# Platform-specific packages to update
PLATFORMS=("linux-x64" "linux-arm64" "darwin-x64" "darwin-arm64")
ARCHS=("x86_64-unknown-linux-musl" "aarch64-unknown-linux-musl" "x86_64-apple-darwin" "aarch64-apple-darwin")

echo ""
echo "Updating to version $LATEST_VERSION..."
echo ""

# Update version in default.nix
sed -i "s/version = \"[^\"]*\";/version = \"$LATEST_VERSION\";/" "$DEFAULT_NIX"

# Update hash for each platform
for i in "${!PLATFORMS[@]}"; do
  platform="${PLATFORMS[$i]}"
  arch="${ARCHS[$i]}"
  tarball="https://registry.npmjs.org/@openai/codex/-/codex-${LATEST_VERSION}-${platform}.tgz"

  echo "Computing hash for $platform ($arch)..."
  hash=$(nix-prefetch-url --type sha256 --unpack "$tarball" 2>/dev/null)
  sri_hash=$(nix hash convert --hash-algo sha256 "$hash")

  if [ -z "$sri_hash" ]; then
    echo "Warning: Failed to compute hash for $platform, using fakeHash"
    sri_hash="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
  fi

  echo "  $platform: $sri_hash"

  # Update hash in default.nix - match the arch line and update the hash on the next line
  sed -i "/arch = \"${arch}\";/,/[}];/{s/hash = \"sha256-[^\"]*\";/hash = \"$sri_hash\";/}" "$DEFAULT_NIX"
done

echo ""
echo "✓ Successfully updated codex-cli to version $LATEST_VERSION"
