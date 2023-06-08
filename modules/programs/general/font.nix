{pkgs, ...}: let
  nerdFonts = pkgs.nerdfonts.override {fonts = ["JetBrainsMono" "NerdFontsSymbolsOnly"];};
in {
  fonts.fontconfig.enable = true;
  home.packages = [
    nerdFonts
    pkgs.jetbrains-mono
  ];
}
