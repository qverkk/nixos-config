#!/usr/bin/env sh
# Fuzzy-pick a tmux session and attach (POSIX; no GNU xargs).
set -eu

name=$(
  tmux list-sessions -F '#{session_name}' |
    fzf --reverse --ansi --height 100% \
      --prompt='  ' \
      --header='Sessions' \
      --pointer='' \
      --color='bg+:#2d4f67,bg:#1f1f28,spinner:#ff9e3b,hl:#c34043' \
      --color='fg:#dcd7ba,gutter:#1f1f28,header:#938aa9,info:#7e9cd8,pointer:#7fb4ca' \
      --color='marker:#98bb6c,fg+:#dcd7ba,prompt:#76946a,hl+:#c34043' \
      --preview 'tmux capture-pane -ep -t {}' \
      --preview-window='right:75%:border-left' \
      --border='none' \
      --bind '?:toggle-preview' \
      --bind 'ctrl-d:preview-page-down,ctrl-u:preview-page-up'
) || true

[ -z "$name" ] && exit 0
exec tmux switch-client -t "=$name"
