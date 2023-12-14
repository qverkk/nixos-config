{pkgs, ...}: {
  home.packages = with pkgs; [
    wireplumber
    pavucontrol
  ];
}
