#!/usr/bin/env sh
# Pipe selection from tmux copy-pipe into the system clipboard (Wayland / macOS / X11).
set -eu

if command -v wl-copy >/dev/null 2>&1; then
  exec wl-copy
fi
if command -v pbcopy >/dev/null 2>&1; then
  exec pbcopy
fi
if command -v xclip >/dev/null 2>&1; then
  exec xclip -selection clipboard
fi
if command -v xsel >/dev/null 2>&1; then
  exec xsel --clipboard --input
fi

cat >/dev/null
