{ pkgs, ... }:
{
  imports = [
    ../modules/programs/development/git/home.nix
    ../modules/programs/development/httptools/home.nix
    ../modules/programs/development/java-development/home.nix
    ../modules/programs/development/neovim/home.nix
    ../modules/programs/development/obsidian/home.nix
    ../modules/programs/development/opencode/home.nix
    ../modules/programs/development/tmux/home.nix
    ../modules/programs/development/zellij/home.nix
    ../modules/programs/general/home/atuin/home.nix
    ../modules/programs/general/home/devenv/home.nix
    ../modules/programs/general/home/direnv/home.nix
    ../modules/programs/general/home/font/home.nix
    ../modules/programs/general/home/ghostty/home.nix
    ../modules/programs/general/home/gimp/home.nix
    ../modules/programs/general/home/keepassxc/home.nix
    ../modules/programs/general/home/kitty/home.nix
    ../modules/programs/general/home/starship/home.nix
    ../modules/programs/general/home/system-utilities/home.nix
    ../modules/programs/general/home/video/home.nix
    ../modules/programs/general/zen-browser
    ../modules/programs/general/zsh/home.nix
    ../modules/programs/social/messaging/home.nix
    ../modules/programs/social/thunderbird/home.nix
  ];

  programs.home-manager.enable = true;

  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes
  '';

  targets.darwin.copyApps = {
    enable = true;
    directory = "Applications/Home Manager Apps";
  };

  home = {
    username = "qverkk";
    homeDirectory = "/Users/qverkk";
    stateVersion = "26.11";

    packages = with pkgs; [
      brave
      jq
      tree
      wget
    ];
  };
}
