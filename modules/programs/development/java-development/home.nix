{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jetbrains.idea-ultimate
    windsurf.fhs
    # jetbrains.idea-community
    jetbrains.webstorm
    git-ignore
    vscode.fhs
    # leetcode-cli
    # gitbutler

    ## kotlin
    ktlint
  ];
}
