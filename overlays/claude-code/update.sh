#!/usr/bin/env nix
#!nix shell --ignore-environment nixpkgs#bash nixpkgs#cacert nixpkgs#coreutils nixpkgs#curl nixpkgs#gnused nixpkgs#gnutar nixpkgs#gzip nixpkgs#nodejs nixpkgs#prefetch-npm-deps nixpkgs#nix --command bash

set -euo pipefail

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
DEFAULT_NIX="$SCRIPT_DIR/default.nix"
LOCKFILE="$SCRIPT_DIR/package-lock.json"

version=$(npm view @anthropic-ai/claude-code version)
tarball=$(npm view @anthropic-ai/claude-code dist.tarball)

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

curl -sL "$tarball" -o "$tmpdir/claude-code.tgz"
tar -xzf "$tmpdir/claude-code.tgz" -C "$tmpdir"

(cd "$tmpdir/package" && npm install --package-lock-only --ignore-scripts --no-audit --no-fund)
cp "$tmpdir/package/package-lock.json" "$LOCKFILE"

hash=$(nix-prefetch-url --type sha256 --unpack "$tarball" 2>/dev/null)
sri_hash=$(nix hash to-sri --type sha256 "$hash")
npm_deps_hash=$(prefetch-npm-deps "$LOCKFILE")

sed -i "s/version = \"[^\"]*\";/version = \"$version\";/" "$DEFAULT_NIX"
sed -i "s|hash = \"sha256-[^\"]*\";|hash = \"$sri_hash\";|" "$DEFAULT_NIX"
sed -i "s|npmDepsHash = \"sha256-[^\"]*\";|npmDepsHash = \"$npm_deps_hash\";|" "$DEFAULT_NIX"
