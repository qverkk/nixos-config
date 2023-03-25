{ config, lib, pkgs, ... }:

{
  home.sessionVariables.STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";

  programs.starship = {
    enable = true;
    settings = {
        add_newline = false;
        format = lib.concatStrings [
          "$line_break"
          "$package"
          "$line_break"
          "$character"
        ];
        scan_timeout = 10;
        character = {
          success_symbol = "➜";
          error_symbol = "➜";
        };
    };
  };

  programs.nushell = {
    enable = true;
    configFile = {
      source = ./config.nu;
    };
    envFile = {
      source = ./env.nu;
    };
  };
}
