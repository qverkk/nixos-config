#!/usr/bin/env sh
# Fuzzy-pick a window in the current session (POSIX; no GNU xargs).
set -eu

line=$(
  tmux list-windows -F '#{window_index}	#{window_name}' |
    fzf --reverse --ansi --height 100% \
      --delimiter '	' --with-nth 2 \
      --prompt='󰖲  ' \
      --header='Windows' \
      --pointer='' \
      --color='bg+:#2d4f67,bg:#1f1f28,spinner:#ff9e3b,hl:#c34043' \
      --color='fg:#dcd7ba,gutter:#1f1f28,header:#938aa9,info:#7e9cd8,pointer:#7fb4ca' \
      --color='marker:#98bb6c,fg+:#dcd7ba,prompt:#76946a,hl+:#c34043' \
      --preview 'tmux capture-pane -ep -t :{1}' \
      --preview-window='right:65%:border-left' \
      --border='none' \
      --bind '?:toggle-preview' \
      --bind 'ctrl-d:preview-page-down,ctrl-u:preview-page-up'
) || true

[ -z "$line" ] && exit 0

# First field is window index (tab-separated).
idx=$(printf '%s\n' "$line" | cut -f1)
exec tmux select-window -t ":$idx"
