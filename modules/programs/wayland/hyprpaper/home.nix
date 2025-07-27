{ pkgs, ... }:
{
  home.packages = with pkgs; [ hyprpaper ];

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ~/.local/share/wallpapers/darkcityscape.jpg
    wallpaper = , ~/.local/share/wallpapers/darkcityscape.jpg
  '';

  xdg.dataFile."wallpapers".source = ../swaybg/wallpapers;
}
