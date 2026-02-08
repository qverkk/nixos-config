{ ... }:
{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    mouse = true;
    keyMode = "vi";
    extraConfig = builtins.readFile ./tmux.conf;
  };
}
