{
  lib,
  pkgs,
  user,
  ...
}: let
  launcher_type = "1";
  launcher_style = "6";
in {
  #  home.file.".config/rofi/off.sh".source = ./off.sh;
  home.file.".config/rofi/launcher.sh".source = ./launcher.sh;
  home.file.".config/rofi/projects.sh".source = ./projects.sh;
  home.file.".config/rofi/tailscale.sh".source = ./tailscale.sh;
  home.file.".config/rofi/launcher_theme.rasi".source = ./launcher_theme.rasi;
  # home.file.".config/rofi".source = "${pkgs.rofi-collection}/share/themes";
  # home.file.".config/rofi-starters/launcher.sh" = {
  #   executable = true;
  #   text = ''
  #     #!/usr/bin/env bash

  #     rofi \
  #         -show drun \
  #         -theme "$HOME/.config/rofi/launchers/type-${launcher_type}"/style-${launcher_style}.rasi
  #   '';
  # };
}
