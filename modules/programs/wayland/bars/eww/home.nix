{ config, pkgs, ... }:

{

  home.packages = with pkgs; [
    jq
    socat
  ];

  programs.eww = {
    enable = true;
    package = pkgs.eww-wayland;
    configDir = ./config;
  };
}
