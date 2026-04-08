#!/usr/bin/env sh
# Fuzzy-pick a tmux session, switch to it, or kill it from the picker.
set -eu

list_sessions() {
  current=$(tmux display-message -p '#S' 2>/dev/null || true)
  tmux list-sessions -F '#{session_name}|#{session_last_attached}' 2>/dev/null | \
    while IFS='|' read -r name last; do
      [ -n "$name" ] || continue
      if [ "$name" = "$current" ]; then
        marker=$(printf '\033[32m[current]\033[0m')
      else
        marker=''
      fi
      [ -n "$last" ] || last=0
      # fields: last_attached, session_name, marker
      printf '%s\t%s\t%s\n' "$last" "$name" "$marker"
    done | sort -t "$(printf '\t')" -k1,1nr | \
    awk -F '\t' -v cur="$current" '
      NR == 1 {
        first = $0
        first_name = $2
        next
      }
      NR == 2 {
        if (first_name == cur) {
          print $0
          print first
          swapped = 1
        } else {
          print first
          print $0
        }
        next
      }
      { print $0 }
      END {
        if (NR == 1) {
          print first
        }
      }
    '
}

while :; do
  out=$(
    list_sessions |
      fzf --reverse --ansi --height 100% \
        --expect=enter,ctrl-x \
        --delimiter='\t' --with-nth=2,3 --nth=2 \
        --prompt='  ' \
        --header='Sessions (previous first, then current; green [current] is active) | Enter: switch, Ctrl-x: kill' \
        --pointer='' \
        --color='bg+:#2d4f67,bg:#1f1f28,spinner:#ff9e3b,hl:#c34043' \
        --color='fg:#dcd7ba,gutter:#1f1f28,header:#938aa9,info:#7e9cd8,pointer:#7fb4ca' \
        --color='marker:#98bb6c,fg+:#dcd7ba,prompt:#76946a,hl+:#c34043' \
        --preview 'tmux capture-pane -ep -t {2}' \
        --preview-window='right:75%:border-left:hidden' \
        --border='none' \
        --bind '?:toggle-preview' \
        --bind 'ctrl-d:preview-page-down,ctrl-u:preview-page-up'
  ) || true

  [ -z "$out" ] && exit 0

  key=$(printf '%s\n' "$out" | sed -n '1p')
  line=$(printf '%s\n' "$out" | sed -n '2p')
  name=$(printf '%s\n' "$line" | cut -f2)
  [ -z "$name" ] && exit 0

  if [ "$key" = "ctrl-x" ]; then
    current=$(tmux display-message -p '#S' 2>/dev/null || true)
    if [ "$name" = "$current" ]; then
      tmux display-message "Cannot kill current session: $name"
      sleep 1
      continue
    fi
    tmux kill-session -t "=$name" 2>/dev/null || tmux display-message "Failed to kill session: $name"
    continue
  fi

  exec tmux switch-client -t "=$name"
done
