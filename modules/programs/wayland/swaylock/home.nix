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
      image = "~/.local/share/wallpapers/wallpaper-2.jpg";
      inside-color = "00000088";
    };
  };
}
