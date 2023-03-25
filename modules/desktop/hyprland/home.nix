{ bar, inputs, config, lib, pkgs, ... }:

{
  imports = [
    inputs.hyprland.homeManagerModules.default
    ../../programs/wayland/bars/eww/home.nix
    (import ../../environment/hypr-variables.nix)
  ] ++
  (import ../../programs/wayland) ++
  (import ../../theme/catppuccin-dark/wayland);


  wayland.windowManager.hyprland = {
    enable = true;
    systemdIntegration = true;
    extraConfig =
      (import ./monitors-decoder.nix {
        inherit lib;
        inherit (config) monitors;
      }) +
      (import ./config.nix { })
    ;
  };
}
