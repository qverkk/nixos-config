{ pkgs, ... }:
{
  imports = [
    ../modules/programs/development/git/home.nix
    ../modules/programs/development/java-development/home.nix
    ../modules/programs/development/neovim/home.nix
    ../modules/programs/development/tmux/home.nix
    ../modules/programs/development/zellij/home.nix
    ../modules/programs/general/home/direnv/home.nix
    ../modules/programs/general/home/font/home.nix
    ../modules/programs/general/home/starship/home.nix
    ../modules/programs/general/zsh/home.nix
  ];

  programs.home-manager.enable = true;

  home = {
    username = "qverkk";
    homeDirectory = "/Users/qverkk";
    stateVersion = "26.11";

    packages = with pkgs; [
      jq
      tree
      wget
    ];
  };
}
