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

  version = "1.6.4";
  pname = "windsurf";

  executableName = "windsurf";
  longName = "Windsurf";
  shortName = "windsurf";

  src = fetchurl {
    url = "https://windsurf-stable.codeiumdata.com/linux-x64/stable/059f29a353ceb14e3fdd2012438042e67a7dde5b/Windsurf-linux-x64-1.6.4.tar.gz";
	sha256 = "sha256-/aCTpPRTWCzJvYZC83yvNMkCNEI6qbuuUISBKVEA48w=";
	# sha256 = lib.fakeSha256;
  };

  sourceRoot = "Windsurf";

  tests = nixosTests.vscodium;

  updateScript = "nil";

  meta = with lib; {
    description = "The first agentic IDE, and then some";
  };
}
