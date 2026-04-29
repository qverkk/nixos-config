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

  version = "2.1.29";
  pname = "windsurf";

  executableName = "windsurf";
  longName = "Windsurf";
  shortName = "windsurf";

  src = fetchurl {
    url = "https://windsurf-stable.codeiumdata.com/linux-x64/stable/5dab04154a4694324d3f81c0885897e41d0d2f82/Windsurf-linux-x64-2.1.29.tar.gz";
    sha256 = "sha256-rVDzBsmesEY1QtP0D9aG8PVZ0EmtAcOOPDcrKGaOuNM=";
    # sha256 = lib.fakeSha256;
  };

  sourceRoot = "Windsurf";

  tests = nixosTests.vscodium;

  updateScript = "nil";

  meta = with lib; {
    description = "The first agentic IDE, and then some";
  };
}
