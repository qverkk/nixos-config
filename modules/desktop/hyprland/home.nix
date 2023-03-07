{ inputs, config, lib, pkgs, ... }:

{
  imports = [
    inputs.hyprland.homeManagerModules.default
    ../../programs/wayland/waybar/waybar.nix
    (import ../../environment/hypr-variables.nix)
  ] ++
  (import ../../programs/wayland);

  #programs.hyprland.enable = true;

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
