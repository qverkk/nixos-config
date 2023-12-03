{
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    hyprpaper
  ];

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ~/.local/share/wallpapers/wallpaper-2.jpg
    wallpaper = , ~/.local/share/wallpapers/wallpaper-2.jpg
  '';

  # systemd.user.services.hyprpaper = {
  #   Unit = {
  #     Description = "Hyprland wallpaper daemon";
  #     PartOf = ["graphical-session.target"];
  #   };
  #   Service = {
  #     ExecStart = "${lib.getExe pkgs.hyprpaper}";
  #     Restart = "on-failure";
  #   };
  #   Install.WantedBy = ["graphical-session.target"];
  # };

  xdg.dataFile."wallpapers".source = ../swaybg/wallpapers;
}
