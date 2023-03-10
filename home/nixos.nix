{ inputs, pkgs, config, ... }:

{
  imports = [
    ../modules/desktop/hyprland/home.nix
    ../modules/desktop/hyprland/monitors-config.nix

    ../optional/home-manager/kitty.nix
    ../optional/home-manager/font.nix
    ../optional/home-manager/intellij.nix
    ../optional/home-manager/syncthing.nix
    ../optional/home-manager/keepassxc.nix

    ../modules/programs/moonlander/home.nix
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
