{ ... }:
{
  services.mako = {
    enable = true;
    #iconPath = "${pkgs.papirus-icon-theme.package}/share/icons/Papirus-Dark";
    settings = {
      defaultTimeout = 12000;
      borderSize = 2;
      padding = "10,20";
      width = 400;
      height = 150;
      font = "CaskaydiaCove Nerd Font 12";
      anchor = "top-center";
    };
    #backgroundColor = "#${colors.base00}dd";
    #borderColor = "#${colors.base03}dd";
    #textColor = "#${colors.base05}dd";
  };
}
