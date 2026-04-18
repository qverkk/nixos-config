#!/usr/bin/env nix
#!nix shell --ignore-environment nixpkgs#bash nixpkgs#cacert nixpkgs#coreutils nixpkgs#curl nixpkgs#gnused nixpkgs#gnutar nixpkgs#gzip nixpkgs#nodejs nixpkgs#prefetch-npm-deps nixpkgs#nix --command bash

set -euo pipefail

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
DEFAULT_NIX="$SCRIPT_DIR/default.nix"
LOCKFILE="$SCRIPT_DIR/package-lock.json"

version=$(npm view @anthropic-ai/claude-code version)
tarball=$(npm view @anthropic-ai/claude-code dist.tarball)
native_tarball="https://registry.npmjs.org/@anthropic-ai/claude-code-linux-x64/-/claude-code-linux-x64-${version}.tgz"

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

curl -sL "$tarball" -o "$tmpdir/claude-code.tgz"
tar -xzf "$tmpdir/claude-code.tgz" -C "$tmpdir"

(cd "$tmpdir/package" && npm install --package-lock-only --ignore-scripts --no-audit --no-fund)
cp "$tmpdir/package/package-lock.json" "$LOCKFILE"

src_hash=$(nix-prefetch-url --type sha256 --unpack "$tarball" 2>/dev/null)
src_sri=$(nix hash convert --hash-algo sha256 "$src_hash")

native_hash=$(nix-prefetch-url --type sha256 --unpack "$native_tarball" 2>/dev/null)
native_sri=$(nix hash convert --hash-algo sha256 "$native_hash")

npm_deps_hash=$(prefetch-npm-deps "$LOCKFILE")

sed -i "s/version = \"[^\"]*\";/version = \"$version\";/" "$DEFAULT_NIX"

# Update nativeBin hash: replace hash on the line after the linux-x64 URL
sed -i "/claude-code-linux-x64.*\.tgz/{n; s|hash = \"sha256-[^\"]*\";|hash = \"$native_sri\";|}" "$DEFAULT_NIX"

# Update src hash: replace hash on the line after the main package URL
sed -i "/@anthropic-ai\/claude-code\/-\/claude-code-/{n; s|hash = \"sha256-[^\"]*\";|hash = \"$src_sri\";|}" "$DEFAULT_NIX"

sed -i "s|npmDepsHash = \"sha256-[^\"]*\";|npmDepsHash = \"$npm_deps_hash\";|" "$DEFAULT_NIX"
