{ pkgs, ... }:
let
  additionalJDKs = with pkgs; [
    openjdk11
	zulu11
  ];
in
{
  home.sessionPath = [ "$HOME/.jdks" ];
  home.file = (
    builtins.listToAttrs (
      builtins.map (jdk: {
        name = ".jdks/${jdk.pname}-${jdk.version}";
        value = {
          source = jdk;
        };
      }) additionalJDKs
    )
  );

  home.packages = with pkgs; [
    jetbrains.idea-ultimate
    windsurf.fhs
    cursor
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
