{ config, pkgs, ... }:

{
  home = {
    sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      XWAYLAND_NO_GLAMOR = "1";
    };
  };
}
