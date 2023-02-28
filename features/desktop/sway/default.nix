{ config, lib, pkgs, ... }:

{
  security.polkit.enable = true;

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "konsole"; 
      startup = [
        {command = "konsole";}
      ];
    };
  };
}
