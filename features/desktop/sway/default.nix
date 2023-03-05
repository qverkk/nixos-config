{ config, lib, pkgs, ... }:

{
  wayland.windowManager.sway = {
    enable = true;
    extraOptions = [ "--unsupported-gpu" ];
    wrapperFeatures.gtk = true;
    systemdIntegration = true;
    config = rec {
      modifier = "Mod4";
      terminal = "kitty"; 
    };
  };
  
  home.packages = with pkgs; [
    swaylock
    swayidle
    wl-clipboard
    mako
  ];
  
  programs.swaylock.settings = {
      color = "353935";
      font-size = 24;
      indicator-idle-visible = false;
      indicator-radius = 100;
      line-color = "ffffff";
      show-failed-attempts = true;
  };
}
