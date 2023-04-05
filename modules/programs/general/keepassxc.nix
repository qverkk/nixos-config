{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    keepassxc
    git-credential-keepassxc
  ];
}

