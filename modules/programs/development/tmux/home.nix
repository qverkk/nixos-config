{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    mouse = true;
    keyMode = "vi";
    extraConfig =
      builtins.readFile ./tmux.conf
      + ''
        # Name new sessions after cwd basename; append -1, -2, … if the name exists.
        set-hook -g session-created "run-shell '${pkgs.writeShellScript "tmux-rename-new-session" ''
          sid=$(tmux display -p '${"#"}{session_id}' 2>/dev/null) || exit 0
          base=$(tmux display -p '${"#"}{b:pane_current_path}' 2>/dev/null) || base=
          case "$base" in
            ""|"/"|".") base=session ;;
          esac
          name=$base
          i=0
          while tmux has-session -t "$name" 2>/dev/null; do
            existing=$(tmux display-message -pt "$name" '${"#"}{session_id}' 2>/dev/null || true)
            if [ "$existing" = "$sid" ]; then
              exit 0
            fi
            i=$((i + 1))
            name="$base-$i"
          done
          exec tmux rename-session -t "$sid" -- "$name"
        ''}'"
      ''
      + ''
        # Git worktree + new session creator (prefix + f).
        # fzf lists local branches; type a new name to create a fresh worktree+branch.
        bind f display-popup -d "#{pane_current_path}" -w 75% -h 65% -E "${pkgs.writeShellScript "tmux-worktree-new" ''
          root=$(git rev-parse --show-toplevel 2>/dev/null) || { printf "Not a git repo.\n"; sleep 1; exit 1; }
          name=$(git -C "$root" branch --format="%(refname:short)" | \
            fzf --reverse --ansi --height 100% --print-query \
                --prompt="  " \
                --header="Worktree: select branch or type a new name" \
                --pointer="" \
                --color="bg+:#2d4f67,bg:#1f1f28,spinner:#ff9e3b,hl:#c34043" \
                --color="fg:#dcd7ba,gutter:#1f1f28,header:#938aa9,info:#7e9cd8,pointer:#7fb4ca" \
                --color="marker:#98bb6c,fg+:#dcd7ba,prompt:#76946a,hl+:#c34043" \
                --border="none" | tail -1)
          [ -z "$name" ] && exit 0
          worktree="$(dirname "$root")/$name"
          if [ ! -d "$worktree" ]; then
            git -C "$root" worktree add "$worktree" "$name" 2>/dev/null || \
              git -C "$root" worktree add -b "$name" "$worktree"
          fi
          tmux new-session -d -s "$name" -c "$worktree" 2>/dev/null
          tmux switch-client -t "$name"
        ''}"
      '';
  };
}
