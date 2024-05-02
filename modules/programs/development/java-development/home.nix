{pkgs, ...}: {
  home.packages = with pkgs; [
    jetbrains.idea-ultimate
    jetbrains.idea-community
    git-ignore
    leetcode-cli
    gitbutler

    ## kotlin
    ktlint
  ];
}
