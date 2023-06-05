{ pkgs, ... }: {
  home.packages = with pkgs; [
    jetbrains.idea-ultimate
    git-ignore
  ];

  programs.eclipse = {
    enable = true;
    package = pkgs.eclipses.eclipse-java;
  };
}
