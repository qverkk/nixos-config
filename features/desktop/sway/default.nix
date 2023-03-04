{ config, lib, pkgs, ... }:

{
  wayland.windowManager.sway = {
    enable = true;
    extraOptions = [ "--unsupported-gpu" ];
    config = rec {
      modifier = "Mod4";
      terminal = "kitty"; 
    };
  };
  
}
