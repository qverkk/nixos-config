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

  version = "1.9600.40";
  pname = "windsurf";

  executableName = "windsurf";
  longName = "Windsurf";
  shortName = "windsurf";

  src = fetchurl {
    url = "https://windsurf-stable.codeiumdata.com/linux-x64/stable/33797ef35c395e31fc2c9c35d2509de83c01fd7c/Windsurf-linux-x64-1.9600.40.tar.gz";
    sha256 = "sha256-MfAXXo82KXrWFcKTydnEmtX7fLgY9JtHC31xzeomV8U=";
    # sha256 = lib.fakeSha256;
  };

  sourceRoot = "Windsurf";

  tests = nixosTests.vscodium;

  updateScript = "nil";

  meta = with lib; {
    description = "The first agentic IDE, and then some";
  };
}
