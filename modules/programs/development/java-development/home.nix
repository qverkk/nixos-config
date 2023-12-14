{pkgs, ...}: {
  home.packages = with pkgs; [
    jetbrains.idea-ultimate
    git-ignore
    leetcode-cli

    ## kotlin
    ktlint
  ];
}
