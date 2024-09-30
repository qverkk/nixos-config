{ pkgs, ... }:
{
  home.packages = with pkgs; [ dua ];

  programs = {
    # ls alternative
    eza = {
      enable = true;
      enableZshIntegration = true;
    };

    # cat alternative
    bat.enable = true;

    # tldr alternative
    tealdeer = {
      enable = true;
      settings = {
        display = {
          compact = true;
        };
        updates = {
          auto_update = true;
        };
      };
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
