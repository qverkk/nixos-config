{ pkgs, ... }:

{
  hardware = {
    bluetooth = {
      enable = true;
      # battery info support
      package = pkgs.bluez5-experimental;
    };
  };

  services.upower.enable = true;
}