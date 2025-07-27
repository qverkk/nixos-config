{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  home.packages = [
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.caskaydia-cove
    pkgs.nerd-fonts.symbols-only
    pkgs.jetbrains-mono
    pkgs.cascadia-code

    pkgs.noto-fonts-emoji
    pkgs.noto-fonts-cjk-sans
    pkgs.font-awesome
    pkgs.symbola
    pkgs.material-icons
    pkgs.fira-code
    pkgs.fira-code-symbols
  ];
}
