{ pkgs, ... }:
{
  programs.regreet = {
    enable = true;
	package = pkgs.regreet;
    settings = fromTOML ''
      [GTK]
      application_prefer_dark_theme = true
    '';
  };
}
