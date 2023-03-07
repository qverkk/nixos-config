{ config, pkgs, ... }:
{
  programs.mako = {
    enable = true;
    #iconPath = "${pkgs.papirus-icon-theme.package}/share/icons/Papirus-Dark";
    font = "FiraCode 12";
    padding = "10,20";
    anchor = "top-center";
    width = 400;
    height = 150;
    borderSize = 2;
    defaultTimeout = 12000;
    #backgroundColor = "#${colors.base00}dd";
    #borderColor = "#${colors.base03}dd";
    #textColor = "#${colors.base05}dd";
  };
}
