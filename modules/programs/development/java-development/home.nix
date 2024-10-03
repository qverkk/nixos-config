{pkgs, ...}: {
  home.packages = with pkgs; [
    jetbrains.idea-ultimate
    # jetbrains.idea-community
    jetbrains.webstorm
    git-ignore
    # leetcode-cli
    # gitbutler

    ## kotlin
    ktlint
  ];
}
