{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vlc
    ani-cli
    # stremio - has vulnerability
  ];
}
