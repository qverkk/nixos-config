{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    grim
    #flameshot
    inputs.hyprland-contrib.packages.${pkgs.hostPlatform.system}.grimblast
    tesseract5
    libnotify
  ];
}
