{ ... }:
{
  imports =
    [
      ../modules/desktop/sway/home.nix
      # ../modules/desktop/hyprland/home.nix
      ../modules/desktop/hyprland/monitors-config.nix

      ../modules/programs/moonlander/home.nix
    ]
    ++ (import ../modules/programs/development/home.nix)
    ++ (import ../modules/programs/social/home.nix)
    ++ (import ../modules/programs/general/home/home.nix)
    ++ (import ../modules/programs/general);

  # Let home manager install and makage itself
  programs.home-manager.enable = true;

  home = {
    username = "qverkk";
    homeDirectory = "/home/qverkk";
    stateVersion = "24.05";
  };

  monitors = [
    {
      name = "eDP-1";
      width = 2560;
      height = 1600;
      refreshRate = 90;
      # width = 1920;
      # height = 1200;
      # refreshRate = 60;
      x = 0;
      workspace = "1";
      scale = "1.75";
      # scale = "1";
      modeline = "";
      custom = "";
    }
    {
      name = "HDMI-A-1";
      x = 2560;
      width = 3440;
      height = 1440;
      refreshRate = 100;
      workspace = "2";
      scale = "1";
    }
  ];
}
