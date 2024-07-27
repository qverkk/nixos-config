{...}: {
  imports =
    [
      # ../modules/desktop/sway/home.nix
      ../modules/desktop/hyprland/home.nix
      ../modules/desktop/hyprland/monitors-config.nix

      ../modules/programs/moonlander/home.nix
      ../modules/programs/docker/home.nix
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
      name = "DP-3";
      width = 3440;
      height = 1440;
      refreshRate = 144;
      x = 0;
      workspace = "1";
      scale = "1";
    }
    {
      name = "DP-1";
      width = 3440;
      height = 1440;
      refreshRate = 144;
      x = 0;
      workspace = "1";
      scale = "1";
    }
  ];
}
