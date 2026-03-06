#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
FLAKE_NIX="$SCRIPT_DIR/../../flake.nix"

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

(cd "$SCRIPT_DIR/../.." && nix flake update opencode)
