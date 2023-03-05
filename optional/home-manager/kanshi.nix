
{ config, lib, pkgs, ... }:

{
  home.packages = [ pkgs.kanshi ];

  services.kanshi = {
    enable = true;
    profiles = {
      deskonly = {
        outputs = [
          {
#            criteria = "Unknown Mi Monitor 0x00000000";
            criteria = "DP-1";
            status = "enable";
            mode = "3440x1440@144Hz";
            scale = 1.0;
            position = "0,0";
          }
        ];
      };
    };
  };
}
