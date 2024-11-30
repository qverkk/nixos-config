{ pkgs, ... }:
let
  # nerdFonts = pkgs.nerd-fonts.override {
  #   fonts = [
  #     "JetBrainsMono"
  #     "NerdFontsSymbolsOnly"
  #     "CascadiaCode"
  #   ];
  # };
in
{
  fonts.fontconfig.enable = true;
  home.packages = [
	pkgs.nerd-fonts.jetbrains-mono
	# pkgs.nerd-fonts.cascadia-code
	pkgs.nerd-fonts.symbols-only
    pkgs.jetbrains-mono
    pkgs.cascadia-code
  ];
}
