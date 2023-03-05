
{ config, lib, pkgs, ... }:

{
  services.kanshi = {
    enable = true;
    profiles = {
      deskonly = {
        outputs = [
          {
            criteria = "Unknown Mi Monitor 0x00000000";
            status = "enable";
            mode = "3440x1440@144Hz";
            scale = 1;
            position = "0.0";
          }
        ]
      }
    };
  };
}
