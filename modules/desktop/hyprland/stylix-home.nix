{ pkgs, ... }:
{

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/black-metal-bathory.yaml";
  stylix.targets = {
    waybar.enable = false;
    rofi.enable = false;
    hyprland.enable = false;
    hyprlock.enable = false;
    ghostty.enable = false;
  };
}
