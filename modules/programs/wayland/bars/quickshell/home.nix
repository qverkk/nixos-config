{ config, pkgs, ... }:
let
  colors = config.lib.stylix.colors;

  # Generate Colors.qml from the active Stylix palette.
  colorsQml = pkgs.writeText "Colors.qml" ''
    pragma Singleton
    import Quickshell
    import QtQuick

    Singleton {
      readonly property color base00: "#${colors.base00}"
      readonly property color base01: "#${colors.base01}"
      readonly property color base02: "#${colors.base02}"
      readonly property color base03: "#${colors.base03}"
      readonly property color base04: "#${colors.base04}"
      readonly property color base05: "#${colors.base05}"
      readonly property color base06: "#${colors.base06}"
      readonly property color base07: "#${colors.base07}"
      readonly property color base08: "#${colors.base08}"
      readonly property color base09: "#${colors.base09}"
      readonly property color base0A: "#${colors.base0A}"
      readonly property color base0B: "#${colors.base0B}"
      readonly property color base0C: "#${colors.base0C}"
      readonly property color base0D: "#${colors.base0D}"
      readonly property color base0E: "#${colors.base0E}"
      readonly property color base0F: "#${colors.base0F}"
    }
  '';

  # Bundle all QML files into a single flat store derivation.
  # Quickshell resolves shell.qml's real path and looks for sibling files
  # in the same directory — so everything must live in one derivation.
  barPackage = pkgs.runCommand "quickshell-bar" { } ''
    mkdir -p $out
    cp ${./qml}/*.qml $out/
    cp ${colorsQml} $out/Colors.qml
  '';
in
{
  home.packages = [
    pkgs.quickshell
    pkgs.blueman
    pkgs.curl
    pkgs."translate-shell"
  ];

  xdg.configFile."quickshell/bar".source = barPackage;
}
