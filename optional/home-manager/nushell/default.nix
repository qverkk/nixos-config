{ config, lib, pkgs, ... }:

{
   programs.nushell = {
    enable = true;
  };
  
  #config = mkIf programs.kitty.enable {
  #  programs.kitty.extraConfig = [
  #    "shell nushell"
  #  ];
  #};
  
  programs.kitty.extraConfig = ''
    "shell nu"
  '';
}
