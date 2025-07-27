{ pkgs, ... }:
{
  imports = [
    ../../theme/stylix
    ../../programs/wayland/greetd
  ];

  programs = {
    dconf.enable = true;
    light.enable = true;
  };

  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [
    #inputs.hypr-contrib.packages.${pkgs.system}.grimblast
    #inputs.hyprpicker.packages.${pkgs.system}.hyprpicker
    #swww
    #swaylock-effects
  ];

  programs.hyprland = {
    enable = true;
  };

  security.pam.services.swaylock = { };
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-gtk
    ];
    configPackages = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
  };
}
