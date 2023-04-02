{ inputs, pkgs, config, ... }:

{
  imports = [
    ../modules/desktop/hyprland/home.nix
    ../modules/desktop/hyprland/monitors-config.nix

    ../optional/home-manager/kitty.nix
    ../optional/home-manager/font.nix
    ../optional/home-manager/intellij.nix
    ../optional/home-manager/syncthing.nix
    ../optional/home-manager/keepassxc.nix
    ../optional/home-manager/obsidian.nix
    #    ../optional/home-manager/nushell
    ../optional/home-manager/messaging.nix
    ../optional/home-manager/starship.nix
    ../optional/home-manager/pipewire.nix
    ../optional/home-manager/mail.nix
    ../optional/home-manager/gimp.nix
    ../optional/home-manager/clipboard.nix
    ../optional/home-manager/spotifyd.nix

    ../modules/programs/moonlander/home.nix
    ../modules/programs/zsh/home.nix
  ];

  # Let home manager install and makage itself
  programs.home-manager.enable = true;

  home = {
    username = "qverkk";
    homeDirectory = "/home/qverkk";
    stateVersion = "22.11";
  };

  monitors = [
    {
      name = "eDP-1";
      width = 3840;
      height = 2160;
      refreshRate = 60;
      x = 0;
      workspace = "1";
    }
  ];
}
