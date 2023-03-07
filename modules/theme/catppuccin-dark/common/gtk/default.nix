{ config, pkgs, inputs, ... }:

rec {
  gtk = {
    enable = true;
    font = {
      name = "FiraCode";
      size = 12;
    };
    theme = {
      name = "SolArc-Dark";
      package = pkgs.solarc-gth-theme;
    };
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
  };

  services.xsettingsd = {
    enable = true;
    settings = {
      "Net/ThemeName" = "${gtk.theme.name}";
      "Net/IconThemeName" = "${gtk.iconTheme.name}";
    };
  };
}
