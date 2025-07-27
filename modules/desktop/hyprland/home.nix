{ config, lib, ... }:
{
  imports = [
    ../../programs/wayland/bars/eww/home.nix
    ./stylix-home.nix
    ../../programs/wayland/bars/waybar/home.nix
    (import ../../environment/hypr-variables.nix)
  ]
  ++ (import ../../programs/wayland/home.nix)
  ++ (import ../../theme/catppuccin-dark/wayland/home.nix);

  home.file.hyprconf = {
    target = ".config/hypr/hyprland.conf";
    text = ''
      ${import ./monitors-decoder.nix {
        inherit lib;
        inherit (config) monitors;
      }}

      ${builtins.readFile ./hyprland.conf}
    '';
  };
}
