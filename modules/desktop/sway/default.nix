{ pkgs, ... }:
let
  extraEnv = {
    WLR_NO_HARDWARE_CURSORS = "1";
    XWAYLAND_NO_GLAMOR = "1";
    # WLR_RENDERER = "vulkan";
    XDG_SESSION_TYPE = "wayland";
    CLUTTER_BACKEND = "wayland";
    XDG_SESSION_DESKTOP = "sway";
    XDG_CURRENT_DESKTOP = "sway";
    DESKTOP_SESSION = "sway";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

    GDK_BACKEND = "wayland";
    MOZ_ENABLE_WAYLAND = "1";

    # WLR Options
    WLR_BACKENDS = "drm,libinput";
    #export WLR_RENDERER=vulkan

    # XWAYLAND_NO_GLAMOR = "0";

    RTC_USE_PIPEWIRE = "true";
    _JAVA_AWT_WM_NONREPARENTING = "1";
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
