{ lib, pkgs, ... }:
{
  home.packages = lib.optionals pkgs.stdenv.isLinux [ pkgs.steam-run ];
}
