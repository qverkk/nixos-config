{ bar, inputs, config, lib, pkgs, ... }:

{
  imports = [
    ../../programs/wayland/bars/eww/home.nix
    (import ../../environment/hypr-variables.nix)
  ] ++
  (import ../../programs/wayland) ++
  (import ../../theme/catppuccin-dark/wayland);


  home.file.hyprconf = {
    target = ".config/hypr/hyprland.conf";
    text = ''
      ${import ./monitors-decoder.nix {
        inherit lib;
        inherit (config) monitors;
      }}

      ${import ./config.nix { }}
    '';
  };

  #  wayland.windowManager.hyprland = {
  #    enable = true;
  #    systemdIntegration = true;
  #    nvidiaPatches = true;
  #    extraConfig =
  #      (import ./monitors-decoder.nix {
  #        inherit lib;
  #        inherit (config) monitors;
  #      }) +
  #      (import ./config.nix { })
  #    ;
  #  };
}
