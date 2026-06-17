#!/bin/sh
set -e

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

cd "$SCRIPT_DIR"

nix --extra-experimental-features nix-command --extra-experimental-features flakes flake update
