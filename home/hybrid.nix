{...}: {
  imports =
    [
      ../modules/desktop/sway/home.nix
      ../modules/desktop/hyprland/monitors-config.nix

      ../modules/programs/moonlander/home.nix
    ]
    ++ (import ../modules/programs/development/home.nix)
    ++ (import ../modules/programs/social/home.nix)
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
      name = "";
      width = 1920;
      height = 1080;
      refreshRate = 60;
      x = 0;
      workspace = "1";
	  enabled = true;
    }
  ];
}
