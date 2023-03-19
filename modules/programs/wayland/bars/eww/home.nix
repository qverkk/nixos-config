{ config, pkgs, ... }:

{

  home.packages = with pkgs; [
    jq
    socat
    iw
  ];

  programs.eww = {
    enable = true;
    package = pkgs.eww-wayland;
    configDir = ./config;
  };
}
