#!/usr/bin/env nix
#!nix shell --ignore-environment nixpkgs#bash nixpkgs#cacert nixpkgs#coreutils nixpkgs#curl nixpkgs#gitMinimal nixpkgs#gnugrep nixpkgs#gnused nixpkgs#nix --command bash

set -euo pipefail

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
FLAKE_NIX="$SCRIPT_DIR/../../flake.nix"
OVERLAYS_DEFAULT="$SCRIPT_DIR/../default.nix"
FLAKE_ROOT="$SCRIPT_DIR/../.."

latest=$(curl -s "https://api.github.com/repos/anomalyco/opencode/releases/latest" | grep '"tag_name"' | sed 's/.*"tag_name": *"\([^"]*\)".*/\1/')

if [ -z "$latest" ]; then
  echo "Failed to fetch latest opencode release" >&2
  exit 1
fi

echo "Latest opencode release: $latest"

current=$(grep 'url = "github:anomalyco/opencode' "$FLAKE_NIX" | sed 's|.*opencode/\([^"]*\)".*|\1|')

if [ "$current" = "$latest" ]; then
  echo "Already on $latest, nothing to do."
  exit 0
fi

sed -i "s|url = \"github:anomalyco/opencode/[^\"]*\";|url = \"github:anomalyco/opencode/$latest\";|" "$FLAKE_NIX"
echo "Updated flake.nix: $current -> $latest"

(cd "$FLAKE_ROOT" && nix flake update opencode)

# Update node_modules hash in overlays/default.nix
echo "Determining new node_modules hash..."

current_hash=$(grep -oP 'hash = "\Ksha256-[^"]+' "$OVERLAYS_DEFAULT" | head -1)
real_hash=""

# Fast path: pull hash directly from upstream hashes.json (instantaneous)
hashes_json=$(curl -sf "https://raw.githubusercontent.com/anomalyco/opencode/$latest/nix/hashes.json" || true)
if [ -n "$hashes_json" ]; then
  real_hash=$(echo "$hashes_json" | grep -oP '"x86_64-linux":\s*"\K[^"]+' || true)
  [ -n "$real_hash" ] && echo "Got hash from upstream hashes.json"
fi

# Slow fallback: fake-hash trick via nix build (takes a few minutes)
if [ -z "$real_hash" ]; then
  echo "hashes.json unavailable or missing x86_64-linux entry, falling back to nix build..."

  FAKE_HASH="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
  sed -i "s|hash = \"sha256-[^\"]*\";|hash = \"$FAKE_HASH\";|" "$OVERLAYS_DEFAULT"

  TEMP_NIX=$(mktemp /tmp/opencode-hash-check.XXXXXX.nix)
  trap 'rm -f "$TEMP_NIX"' EXIT

  # <<'NIXEOF' prevents bash from expanding ${src} (Nix interpolation); inject fake hash via sed
  sed "s|FAKE_HASH_HERE|$FAKE_HASH|" > "$TEMP_NIX" <<'NIXEOF'
let
  flake = builtins.getFlake (toString ./.);
  pkgs = flake.inputs.nixpkgs.legacyPackages.x86_64-linux;
  src = flake.inputs.opencode.sourceInfo;
  rev = src.shortRev or "dirty";
in pkgs.callPackage "${src}/nix/node_modules.nix" { inherit rev; hash = "FAKE_HASH_HERE"; }
NIXEOF

  build_output=$(cd "$FLAKE_ROOT" && nix build --impure --no-link --expr "$(cat "$TEMP_NIX")" 2>&1 || true)
  real_hash=$(echo "$build_output" | grep -oP 'got:\s*\K\S+' | head -1)

  if [ -z "$real_hash" ]; then
    echo "Failed to determine new node_modules hash. Restoring original." >&2
    sed -i "s|hash = \"$FAKE_HASH\";|hash = \"$current_hash\";|" "$OVERLAYS_DEFAULT"
    echo "$build_output" >&2
    exit 1
  fi
fi

sed -i "s|hash = \"sha256-[^\"]*\";|hash = \"$real_hash\";|" "$OVERLAYS_DEFAULT"
echo "Updated node_modules hash: $current_hash -> $real_hash"
