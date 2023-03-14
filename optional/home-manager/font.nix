{ lib, config, pkgs, ... }:

let
  nerdFira = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
in
{
  fonts.fontconfig.enable = true;
  home.packages = [
    nerdFira
    pkgs.jetbrains-mono
  ];
}
