{ pkgs, ...}:

{
  home.packages = with pkgs; [
    zsa-udev-rules
    wally-cli
  ];
}
