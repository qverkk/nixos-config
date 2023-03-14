{ lib, config, pkgs, ... }:

let
  nerdFonts = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
in
{
  fonts.fontconfig.enable = true;
  home.packages = [
    nerdFonts
    pkgs.jetbrains-mono
  ];
}
