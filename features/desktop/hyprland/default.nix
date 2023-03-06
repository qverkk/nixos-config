{ inputs, config, lib, pkgs, ... }:

{
  imports = [
    inputs.hyprland.homeManagerModules.default
    ../common/waybar.nix
  ];

  #programs.hyprland.enable = true;
  wayland.windowManager.hyprland.enable = true;

  home.packages = with pkgs; [
    wofi
  ];

  wayland.windowManager.hyprland.extraConfig =
    (import ./monitors.nix {
      inherit lib;
      inherit (config) monitors;
    }) +
    (import ./config.nix { })
  ;
}
