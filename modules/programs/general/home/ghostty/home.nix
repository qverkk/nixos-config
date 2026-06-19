{ lib, pkgs, ... }:
let
  settings = {
    gtk-titlebar = false; # better on tiling wm
    font-size = 14;
    font-family = "CaskaydiaCove Nerd Font Mono";
    window-theme = "dark";
    theme = "Dark Pastel";
  };

  configText =
    builtins.readFile ./config
    + lib.concatStringsSep "" (
      lib.mapAttrsToList (name: value: ''
        ${name} = ${toString value}
      '') settings
    );
in
{
  config = lib.mkMerge [
    (lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      # imports = [
      #   inputs.ghostty-hm.homeModules.default
      # ];

      programs.ghostty = {
        enable = true;
        package = pkgs.ghostty;
        # shellIntegration = true;
        inherit settings;
      };
    })

    (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
      home.packages = [ pkgs.ghostty-bin ];

      home.file."Library/Application Support/com.mitchellh.ghostty/config".text = configText;
    })
  ];
}
