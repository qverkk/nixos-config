{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    keepassxc
  ];
}

