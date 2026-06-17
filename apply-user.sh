#!/bin/sh
set -e

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SYSTEM=$(uname -s)

cd "$SCRIPT_DIR"

if [ -z "$1" ]; then
  user=$(whoami)
  if [ "$SYSTEM" = "Darwin" ]; then
    host=moonder
  else
    host=$(hostname)
  fi
  target="$user@$host"
else
  case "$1" in
    *@*) target=$1 ;;
    *) target="$(whoami)@$1" ;;
  esac
fi

nix --extra-experimental-features nix-command --extra-experimental-features flakes \
  build ".#homeConfigurations.${target}.activationPackage" --show-trace

./result/activate
