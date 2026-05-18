{
  lib,
  stdenv,
  pkgs,
  buildVscode,
  fetchurl,
  nixosTests,
  commandLineArgs ? "",
}:
# https://windsurf-stable.codeium.com/api/update/linux-x64/stable/latest
# https://windsurf-next.codeium.com/api/update/linux-x64/stable/latest
buildVscode {
  inherit commandLineArgs;
  useVSCodeRipgrep = true;

  version = "2.3.9";
  pname = "windsurf";

  executableName = "windsurf";
  longName = "Windsurf";
  shortName = "windsurf";

  src = fetchurl {
    url = "https://windsurf-stable.codeiumdata.com/linux-x64/stable/a5d3f1ff990cabc0e8001cce6642bdb7ad429e73/Windsurf-linux-x64-2.3.9.tar.gz";
    sha256 = "sha256-h0AkdEzYU7fDUP5RS+GbAGD6w5WGJTw7dgLWhpRz6tw=";
    # sha256 = lib.fakeSha256;
  };

  sourceRoot = "Windsurf";

  tests = nixosTests.vscodium;

  updateScript = "nil";

  meta = with lib; {
    description = "The first agentic IDE, and then some";
  };
}
