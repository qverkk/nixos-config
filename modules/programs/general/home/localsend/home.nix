{
  hostName,
  lib,
  pkgs,
  ...
}:
{
  home.packages =
    lib.optionals
      (builtins.elem hostName [
        "moonder"
        "yogi"
        "nixos"
      ])
      [
        pkgs.localsend
      ];
}
