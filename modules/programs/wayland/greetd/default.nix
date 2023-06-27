{ pkgs, ... }: {
  programs.regreet = {
    enable = true;
    settings = fromTOML ''
      [GTK]
      application_prefer_dark_theme = true
    '';
  };
}
