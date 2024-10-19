{ pkgs, ... }:
let
  extraEnv = {
    WLR_NO_HARDWARE_CURSORS = "1";
    XWAYLAND_NO_GLAMOR = "1";
    # WLR_RENDERER = "vulkan";
  };
in
{
  imports = [ ../../programs/wayland/greetd ];
  programs = {
    dconf.enable = true;
    light.enable = true;
  };

  services.desktopManager.plasma6.enable = true;

  environment.variables = extraEnv;
  environment.sessionVariables = extraEnv;

  security.pam.services.swaylock = { };
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
    config.sway.default = [
      "wlr"
      "gtk"
    ];
  };
}
