{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wl-clipboard
    xdg-utils
  ];
}
