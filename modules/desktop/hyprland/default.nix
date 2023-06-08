{pkgs, ...}: {
  programs = {
    dconf.enable = true;
    light.enable = true;
  };

  environment.systemPackages = with pkgs; [
    #inputs.hypr-contrib.packages.${pkgs.system}.grimblast
    #inputs.hyprpicker.packages.${pkgs.system}.hyprpicker
    #swww
    #swaylock-effects
  ];

  programs.hyprland = {
    enable = true;
    nvidiaPatches = true;
  };

  security.pam.services.swaylock = {};
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };
}
