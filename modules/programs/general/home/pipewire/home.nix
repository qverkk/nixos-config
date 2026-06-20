{ lib, pkgs, ... }:
{
  home.packages = lib.optionals pkgs.stdenv.isLinux (
    with pkgs;
    [
      wireplumber
      pavucontrol
    ]
  );
}
