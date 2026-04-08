{ config, lib, ... }:
let
  scriptDir = "${config.xdg.configHome}/tmux/scripts";
  scriptSources = {
    "copy-to-system.sh" = ./scripts/copy-to-system.sh;
    "fzf-list-keys.sh" = ./scripts/fzf-list-keys.sh;
    "fzf-switch-session.sh" = ./scripts/fzf-switch-session.sh;
    "fzf-switch-window.sh" = ./scripts/fzf-switch-window.sh;
    "rename-new-session.sh" = ./scripts/rename-new-session.sh;
    "worktree-new.sh" = ./scripts/worktree-new.sh;
  };
  tmuxConf =
    builtins.replaceStrings [ "@tmux_script_dir@" ] [ scriptDir ] (builtins.readFile ./tmux.conf);
in
{
  xdg.configFile = lib.mapAttrs' (
    name: source:
    lib.nameValuePair "tmux/scripts/${name}" {
      inherit source;
      executable = true;
    }
  ) scriptSources;

  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    mouse = true;
    keyMode = "vi";
    extraConfig =
      tmuxConf
      + ''

        # Reload Home Manager–generated tmux.conf (prefix C-b then C-r).
        bind C-r run-shell 'tmux source-file ${config.xdg.configHome}/tmux/tmux.conf'
      '';
  };
}
