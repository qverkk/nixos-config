{ inputs, pkgs, ... }:
{
  imports = [
    inputs.ghostty-hm.homeModules.default
  ];

  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;
    # shellIntegration = true;
    settings = {
      gtk-titlebar = false; # better on tiling wm
      font-size = 14;
	  font-family = "CaskaydiaCove Nerd Font Mono";
      window-theme = "dark";
      theme = "Dark Pastel";
    };
  };
}
