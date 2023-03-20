{ config, pkgs, ... }:

{

  home.packages = with pkgs; [
    jq
    socat
    iw
    playerctl
    bc
  ];

  programs.eww = {
    enable = true;
    package = pkgs.eww-wayland;
    configDir = ./config;
  };
}
