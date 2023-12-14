{pkgs, ...}: {
  home.packages = with pkgs; [
    swaybg
  ];

  xdg.dataFile."wallpapers".source = ./wallpapers;
}
