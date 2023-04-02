{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    enableVteIntegration = true;
    autocd = true;
    dotDir = ".config/zsh";
    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = true;
      save = 10000;
      share = true;
    };
    initExtra = ''
      # make nix-shell use zsh
      ${pkgs.any-nix-shell}/bin/any-nix-shell zsh | source /dev/stdin
    '';
  };
}
