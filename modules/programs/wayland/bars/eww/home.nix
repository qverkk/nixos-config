{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    jq
    socat
    iw
    playerctl
    bc
    bluez5
    blueman
    upower
    brightnessctl
  ];

  programs.eww = {
    enable = true;
    configDir = ./config;
  };
}
