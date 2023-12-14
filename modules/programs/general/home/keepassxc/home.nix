{pkgs, ...}: {
  home.packages = with pkgs; [
    keepassxc
    git-credential-keepassxc
  ];
}
