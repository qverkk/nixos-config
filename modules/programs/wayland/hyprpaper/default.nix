{pkgs, ...}: {
  home.packages = with pkgs; [
    hyprpaper
  ];

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ~/.local/share/wallpapers/wallpaper-2.jpg
    wallpaper = , ~/.local/share/wallpapers/wallpaper-2.jpg
  '';

  xdg.dataFile."wallpapers".source = ../swaybg/wallpapers;
}
