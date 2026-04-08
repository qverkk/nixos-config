#!/usr/bin/env sh
# Fuzzy-find tmux keybindings in a popup.
set -eu

tmux list-keys -N | \
  fzf --reverse --ansi --height 100% \
    --prompt='?  ' \
    --header='Keybindings (type to narrow)' \
    --pointer='' \
    --color='bg+:#2d4f67,bg:#1f1f28,spinner:#ff9e3b,hl:#c34043' \
    --color='fg:#dcd7ba,gutter:#1f1f28,header:#938aa9,info:#7e9cd8,pointer:#7fb4ca' \
    --color='marker:#98bb6c,fg+:#dcd7ba,prompt:#76946a,hl+:#c34043' \
    --border='none'
