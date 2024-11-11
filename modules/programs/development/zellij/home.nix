{ ... }:
{
  home.file.zellij-default-layout = {
    target = ".config/zellij/layout_default.kdl";
    text = ${builtins.readFile ./layout_default.kdl};
  };

  home.file.zellij = {
    target = ".config/zellij/config.kdl";
    text =       ${builtins.readFile ./config.kdl}
  };
  programs.zellij = {
    enable = true;
  };
}
