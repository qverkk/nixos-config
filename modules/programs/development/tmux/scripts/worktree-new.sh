#!/usr/bin/env sh
# Git worktree picker: fzf branches or type a new name; open tmux session in worktree.
set -eu

die() {
  printf '%s\n' "$1"
  sleep 4
  exit 1
}

tab=$(printf '\t')

current_repo_root() {
  git rev-parse --show-toplevel 2>/dev/null
}

build_worktree_map() {
  root_out=
  path=
  first=true
  while IFS= read -r line; do
    case "$line" in
      worktree\ *)
        path=${line#worktree }
        if [ "$first" = true ]; then
          root_out=$path
          first=false
        fi
        ;;
      branch\ refs/heads/*)
        branch=${line#branch refs/heads/}
        printf '%s%s%s\n' "$path" "$tab" "$branch" >> "$wtmap"
        ;;
    esac
  done <<EOF
$(git -C "$here" worktree list --porcelain)
EOF
  [ -n "$root_out" ] || die "Could not determine primary worktree root."
  root=$root_out
}

worktree_for_branch() {
  branch=$1
  found=
  while IFS="$tab" read -r map_path map_branch; do
    if [ "$map_branch" = "$branch" ]; then
      found=$map_path
      break
    fi
  done < "$wtmap"
  [ -n "$found" ] && printf '%s\n' "$found"
}

branch_status_line() {
  branch=$1
  checkout=$(worktree_for_branch "$branch" || true)
  if [ -z "$checkout" ]; then
    mark=$(printf '\033[2m—\033[0m  (no checkout)')
  elif [ "$checkout" = "$root" ]; then
    mark=$(printf '\033[32m[main]\033[0m  primary worktree')
  else
    case "$checkout" in
      "$root"/*) rel=${checkout#"${root}/"} ;;
      *) rel=$checkout ;;
    esac
    mark=$(printf '\033[33m[+wt]\033[0m  %s' "$rel")
  fi
  printf '%s%s%s\n' "$branch" "$tab" "$mark"
}

pick_branch() {
  git -C "$root" branch --format='%(refname:short)' |
    while IFS= read -r branch; do
      [ -n "$branch" ] || continue
      branch_status_line "$branch"
    done |
    fzf --reverse --ansi --height 100% --print-query \
      --delimiter "$tab" --with-nth 1,2 --nth 1 \
      --prompt='  ' \
      --header='[main] = primary repo   [+wt] = linked worktree   — = branch not checked out' \
      --pointer='' \
      --color='bg+:#2d4f67,bg:#1f1f28,spinner:#ff9e3b,hl:#c34043' \
      --color='fg:#dcd7ba,gutter:#1f1f28,header:#938aa9,info:#7e9cd8,pointer:#7fb4ca' \
      --color='marker:#98bb6c,fg+:#dcd7ba,prompt:#76946a,hl+:#c34043' \
      --border='none' |
    tail -n 1
}

ensure_worktree_exists() {
  branch=$1
  target=$2
  if git -C "$target" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    return
  fi

  mkdir -p "$(dirname "$target")"
  if git -C "$root" show-ref --verify --quiet "refs/heads/$branch"; then
    git -C "$root" worktree add "$target" "$branch" \
      || die "git worktree add failed. Remove stale paths (git worktree list) or fix errors above."
  else
    git -C "$root" worktree add -b "$branch" "$target" \
      || die "git worktree add -b failed; see errors above."
  fi
}

here=$(current_repo_root) || {
  printf 'Not a git repo.\n'
  sleep 1
  exit 1
}

wtmap=$(mktemp "${TMPDIR:-/tmp}/wt-new.XXXXXX") || die "mktemp failed"
trap 'rm -f "$wtmap"' EXIT INT HUP

build_worktree_map

name=$(pick_branch || true)
[ -n "$name" ] || exit 0
name=${name%%"${tab}"*}

preferred="$root/.workflow/$name"
existing_path=$(worktree_for_branch "$name" || true)

if [ -n "$existing_path" ]; then
  if ! git -C "$existing_path" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    die "Git still registers this branch at $existing_path but that path is missing. Try: git worktree prune"
  fi
  worktree=$existing_path
else
  worktree=$preferred
  ensure_worktree_exists "$name" "$worktree"
fi

# Tmux targets use / and : as separators — never use raw branch names as session names.
repo_slug=$(basename "$root")
branch_slug=$(printf '%s' "$name" | tr '/:' '__')
tmux_session="${repo_slug}__${branch_slug}"

# Main repo checkout: preferred is under .workflow/… but the branch already lives on the primary
# worktree ($root) — use that path; never suggest moving the whole repo into .workflow/.
if [ "$worktree" != "$preferred" ] && [ "$worktree" != "$root" ]; then
  printf 'Using linked checkout outside .workflow/:\n  %s\n\nTo move under .workflow/: git worktree move \"%s\" \"%s\"\n' \
    "$worktree" "$worktree" "$preferred"
  sleep 2
fi

if ! tmux has-session -t "=$tmux_session" 2>/dev/null; then
  tmux new-session -d -s "$tmux_session" -c "$worktree" \
    || die "tmux new-session failed."
fi
exec tmux switch-client -t "=$tmux_session"
