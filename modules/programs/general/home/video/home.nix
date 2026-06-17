{ lib, pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      ani-cli
      mpv
      # stremio - has vulnerability
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      vlc
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
      iina
    ];
}
