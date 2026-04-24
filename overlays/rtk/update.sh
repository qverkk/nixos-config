#!/usr/bin/env nix
#!nix shell --ignore-environment nixpkgs#bash nixpkgs#cacert nixpkgs#coreutils nixpkgs#curl nixpkgs#gnused nixpkgs#nix nixpkgs#jq --command bash

set -euo pipefail

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
DEFAULT_NIX="$SCRIPT_DIR/default.nix"
REPO_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)

latest=$(curl -fsSL "https://api.github.com/repos/rtk-ai/rtk/releases/latest" | jq -r '.tag_name | ltrimstr("v")')

if [ -z "$latest" ] || [ "$latest" = "null" ]; then
  printf 'Failed to fetch latest rtk release\n' >&2
  exit 1
fi

current=$(sed -n 's/^[[:space:]]*version = "\([^"]*\)";.*/\1/p' "$DEFAULT_NIX")

if [ -z "$current" ]; then
  printf 'Failed to read current version from %s\n' "$DEFAULT_NIX" >&2
  exit 1
fi

if [ "$current" = "$latest" ]; then
  printf 'Already on %s, nothing to do.\n' "$latest"
  exit 0
fi

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

src_hash=$(nix-prefetch-url --type sha256 --unpack "https://github.com/rtk-ai/rtk/archive/refs/tags/v${latest}.tar.gz" 2>/dev/null)
src_sri=$(nix hash convert --hash-algo sha256 "$src_hash")

sed -i 's/version = "'"$current"'";/version = "'"$latest"'";/' "$DEFAULT_NIX"
sed -i 's|hash = "sha256-[^"]*";|hash = "'"$src_sri"'";|' "$DEFAULT_NIX"
sed -i 's|cargoHash = "sha256-[^"]*";|cargoHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";|' "$DEFAULT_NIX"

if ! nix build --impure --no-link --print-out-paths --expr '
  let
    flake = builtins.getFlake (toString '"$REPO_DIR"');
  in
  flake.nixosConfigurations.nixos.pkgs.rtk
' >"$tmpdir/build.log" 2>&1; then
  cargo_hash=$(sed -n 's/.*got:[[:space:]]*\(sha256-[A-Za-z0-9+/=]*\).*/\1/p' "$tmpdir/build.log" | tail -n 1)

  if [ -z "$cargo_hash" ]; then
    sed -n '/got:/p' "$tmpdir/build.log" >&2
    printf 'Failed to extract cargoHash from build output\n' >&2
    exit 1
  fi

  sed -i 's|cargoHash = "sha256-[^"]*";|cargoHash = "'"$cargo_hash"'";|' "$DEFAULT_NIX"
fi

printf 'Updated rtk to %s\n' "$latest"
