{ pkgs, ... }:

{
  home.packages = with pkgs; [
    grim
    flameshot
  ];
}