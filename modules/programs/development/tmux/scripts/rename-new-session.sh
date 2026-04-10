#!/usr/bin/env sh
# session-created hook: generate readable session names with project prefix for git worktrees.
set -eu

primary_worktree_root() {
  local_dir=$1
  root=
  while IFS= read -r line; do
    case "$line" in
      worktree\ *)
        root=${line#worktree }
        break
        ;;
    esac
  done <<EOF
$(git -C "$local_dir" worktree list --porcelain)
EOF
  [ -n "$root" ] && printf '%s\n' "$root"
}

session_base_from_path() {
  cwd=$1
  if ! here=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null); then
    base=$(basename "$cwd")
    case "$base" in
      ""|"/"|".") printf 'session\n' ;;
      *) printf '%s\n' "$base" ;;
    esac
    return
  fi

  root=$(primary_worktree_root "$here")
  [ -n "$root" ] || root=$here
  repo_slug=$(basename "$root")

  if [ "$here" = "$root" ]; then
    printf '%s\n' "$repo_slug"
    return
  fi

  case "$here" in
    "$root"/*)
      suffix=${here#"${root}/"}
      case "$suffix" in
        .workflow/*) suffix=${suffix#.workflow/} ;;
      esac
      [ -n "$suffix" ] || suffix=wt
      ;;
    *)
      suffix=$(basename "$here")
      ;;
  esac
  suffix=$(printf '%s' "$suffix" | tr '/:' '__')
  printf '%s__%s\n' "$repo_slug" "$suffix"
}

sid=$(tmux display -p '#{session_id}' 2>/dev/null) || exit 0
cwd=$(tmux display -p '#{pane_current_path}' 2>/dev/null) || cwd=
case "$cwd" in
  ""|"/"|".") base=session ;;
  *) base=$(session_base_from_path "$cwd") ;;
esac

name=$base
i=0
while tmux has-session -t "$name" 2>/dev/null; do
  existing=$(tmux display-message -pt "$name" '#{session_id}' 2>/dev/null || true)
  if [ "$existing" = "$sid" ]; then
    exit 0
  fi
  i=$((i + 1))
  name="$base-$i"
done
exec tmux rename-session -t "$sid" -- "$name"
