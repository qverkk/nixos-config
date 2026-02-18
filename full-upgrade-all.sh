#!/bin/sh
set -e

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

(cd "$SCRIPT_DIR/overlays/cursor" && ./update.sh)
(cd "$SCRIPT_DIR/overlays/windsurf" && ./update.sh)
(cd "$SCRIPT_DIR/overlays/claude-code" && ./update.sh)
(cd "$SCRIPT_DIR/overlays/jdt-ls" && ./update.sh)

(cd "$SCRIPT_DIR" && ./full-upgrade.sh)
