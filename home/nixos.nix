{ inputs, pkgs, config, ... }:

{
  imports = [
    ../modules/desktop/hyprland/home.nix
    ../modules/desktop/hyprland/monitors-config.nix

    ../modules/programs/moonlander/home.nix
  ] ++
  (import ../modules/programs/development) ++
  (import ../modules/programs/social) ++
  (import ../modules/programs/general);

  # Let home manager install and makage itself
  programs.home-manager.enable = true;

  home = {
    username = "qverkk";
    homeDirectory = "/home/qverkk";
    stateVersion = "22.11";
  };

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
