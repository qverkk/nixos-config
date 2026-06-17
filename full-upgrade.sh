#!/bin/sh
set -e

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SYSTEM=$(uname -s)

"$SCRIPT_DIR/update.sh"

case "$SYSTEM" in
  Darwin)
    "$SCRIPT_DIR/apply-system.sh" "$@"
    ;;
  Linux)
    "$SCRIPT_DIR/apply-user.sh" "$@"
    "$SCRIPT_DIR/apply-system.sh" "$@"
    ;;
  *)
    echo "Unsupported system: $SYSTEM" >&2
    exit 1
    ;;
esac
