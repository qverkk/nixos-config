{ config, pkgs, ... }:
{
  home.packages = [ pkgs.hyprpaper ];

  xdg.dataFile."wallpapers".source = ../swaybg/wallpapers;

  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      wallpaper = [
        {
          monitor = "";
          path = "${config.home.homeDirectory}/.local/share/wallpapers/darkcityscape.jpg";
        }
      ];
    };
  };
}
