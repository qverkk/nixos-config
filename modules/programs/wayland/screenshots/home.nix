{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    grim
    #flameshot
    inputs.hyprland-contrib.packages.${pkgs.stdenv.hostPlatform.system}.grimblast
    slurp
    tesseract5
    libnotify
  ];
}
