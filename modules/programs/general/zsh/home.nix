{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting = {
      enable = true;
    };
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
      eval $(ssh-agent -s)
      export EDITOR=nvim
      autoload -z edit-command-line
      zle -N edit-command-line
      bindkey "^X^E" edit-command-line
    '';
  };
}
