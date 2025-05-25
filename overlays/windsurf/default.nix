{
  lib,
  stdenv,
  pkgs,
  callPackage,
  fetchurl,
  nixosTests,
  commandLineArgs ? "",
}:
# https://windsurf-stable.codeium.com/api/update/linux-x64/stable/latest
# https://windsurf-next.codeium.com/api/update/linux-x64/stable/latest
callPackage "${pkgs.path}/pkgs/applications/editors/vscode/generic.nix" rec {
  inherit commandLineArgs;
  useVSCodeRipgrep = true;

  version = "1.9.2";
  pname = "windsurf";

  executableName = "windsurf";
  longName = "Windsurf";
  shortName = "windsurf";

  src = fetchurl {
    url = "https://windsurf-stable.codeiumdata.com/linux-x64/stable/8cb7f313303c8b35844a56b6fe0f76e508261569/Windsurf-linux-x64-1.9.2.tar.gz";
    sha256 = "sha256-7lpKw4+aJRilRCnLI1uudtdLP/8PWUfb/ClzjXjyhUI=";
    # sha256 = lib.fakeSha256;
  };

  sourceRoot = "Windsurf";

  tests = nixosTests.vscodium;

  updateScript = "nil";

  meta = with lib; {
    description = "The first agentic IDE, and then some";
  };
}
