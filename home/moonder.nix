{ pkgs, ... }:
{
  imports = [
    ../modules/programs/general/home/ghostty/home.nix
  ]
  ++ (import ../modules/programs/development/home.nix)
  ++ (import ../modules/programs/social/home.nix)
  ++ (import ../modules/programs/general/home/home.nix)
  ++ (import ../modules/programs/general);

  programs.home-manager.enable = true;

  # xdg.configFile."nix/nix.conf".text = ''
  #   experimental-features = nix-command flakes
  # '';

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
