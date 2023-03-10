{ config, pkgs, ... }:

{
  home = {
    sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      XWAYLAND_NO_GLAMOR = "1";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      SDL_VIDEODRIVER = "wayland";
      XDG_SESSION_TYPE = "wayland";
    };
  };
}
