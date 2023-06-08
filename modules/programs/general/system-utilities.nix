{pkgs, ...}: {
  home.packages = with pkgs; [
    dua
  ];

  programs = {
    # ls alternative
    exa = {
      enable = true;
      enableAliases = true;
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
  };
}
