{ lib, config, pkgs, ... }:

let
  nerdFira = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
in
{
  fonts.fontconfig.enable = true;
  home.packages = [
    nerdFira
    pkgs.fira-code
  ];
}
