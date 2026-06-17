#!/bin/sh
set -e

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SYSTEM=$(uname -s)

cd "$SCRIPT_DIR"

case "$SYSTEM" in
  Darwin)
    HOST=${1:-moonder}

    nix --extra-experimental-features nix-command --extra-experimental-features flakes \
      build ".#darwinConfigurations.${HOST}.system"

    if command -v darwin-rebuild >/dev/null 2>&1; then
      sudo darwin-rebuild switch --flake ".#${HOST}"
    else
      sudo ./result/sw/bin/darwin-rebuild switch --flake ".#${HOST}"
    fi
    ;;
  Linux)
    HOST=${1:-$(hostname)}
    sudo nixos-rebuild switch --flake ".#${HOST}"
    ;;
  *)
    echo "Unsupported system: $SYSTEM" >&2
    exit 1
    ;;
esac
