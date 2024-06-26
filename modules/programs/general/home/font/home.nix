{pkgs, ...}: let
  nerdFonts = pkgs.nerdfonts.override {fonts = ["JetBrainsMono" "NerdFontsSymbolsOnly" "CascadiaCode"];};
in {
  fonts.fontconfig.enable = true;
  home.packages = [
    nerdFonts
    pkgs.jetbrains-mono
	pkgs.cascadia-code
  ];
}
