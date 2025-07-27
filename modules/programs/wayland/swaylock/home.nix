{ pkgs, ... }:
{
  # home.packages = with pkgs; [
  #   swaylock-effects
  # ];

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      effect-blur = "20x3";
      fade-in = 0.1;
      clock = true;
      image = "~/.local/share/wallpapers/darkcityscape.jpg";
      inside-color = "00000088";
    };
  };
}
