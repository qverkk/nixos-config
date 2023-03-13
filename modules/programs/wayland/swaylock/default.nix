{ pkgs, ... }:

{
  home.packages = with pkgs; [
    swaylock-effects
  ];

  programs.swaylock = {
    settings = {
      effect-blur = "20x3";
      fade-in = 0.1;
    };
  };
}
