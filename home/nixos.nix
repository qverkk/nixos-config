{ inputs, pkgs, config, ... }:

{
  imports = [
    #../features/desktop/sway

    ../features/desktop/hyprland
    ../features/desktop/common/mako.nix
    ../optional/home-manager/hyprland-monitors.nix

    ../optional/home-manager/kitty.nix
    ../optional/home-manager/font.nix
    ../optional/home-manager/intellij.nix
    ../optional/home-manager/syncthing.nix
  ];

  # Let home manager install and makage itself
  programs.home-manager.enable = true;


  home = {
    username = "qverkk";
    homeDirectory = "/home/qverkk";
    stateVersion = "22.11";
  };

  programs.helix.enable = true;

  monitors = [
    {
      name = "DP-1";
      width = 3440;
      height = 1440;
      refreshRate = 144;
      x = 0;
      workspace = "1";
    }
  ];
}
