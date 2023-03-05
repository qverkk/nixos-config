{ inputs, pkgs, ... }:

{
  imports = [
    #../features/desktop/sway
    ../features/desktop/hyprland

    ../optional/home-manager/kitty.nix
    ../optional/home-manager/font.nix
    ../optional/home-manager/nushell
  ];
  
  # Let home manager install and makage itself
  programs.home-manager.enable = true;

  home = {
    username = "qverkk";
    homeDirectory = "/home/qverkk";
    stateVersion = "22.11";
  };

  programs.helix.enable = true;

  #monitors = [
  #  {
  #    name = "DP-0";
  #    width = 3440;
  #    height = 1440;
  #    isPrimary = true;
  #    refreshRate = 144;
  #    x = 0;
  #    workspace = "1";
  #  }
  #];
}
