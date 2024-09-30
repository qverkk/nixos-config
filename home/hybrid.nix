{ ... }:
{
  imports =
    [
      # ../modules/desktop/sway/home.nix
      ../modules/desktop/hyprland/home.nix
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
    stateVersion = "23.11";
  };

  monitors = [
    {
      name = "eDP-1";
      width = 1920;
      height = 1080;
      refreshRate = 60;
      x = 0;
      workspace = "1";
      scale = "1";
      modeline = "173.00 1920 2048 2248 2576 1080 1083 1088 1120 -hsync +vsync";
      custom = "1920x1080@60Hz";
    }
  ];
}
