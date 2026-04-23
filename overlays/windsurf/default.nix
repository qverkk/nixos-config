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

  version = "2.0.67";
  pname = "windsurf";

  executableName = "windsurf";
  longName = "Windsurf";
  shortName = "windsurf";

  src = fetchurl {
    url = "https://windsurf-stable.codeiumdata.com/linux-x64/stable/08b5de9bae1728a5ad46386c9b8903192a125c51/Windsurf-linux-x64-2.0.67.tar.gz";
    sha256 = "sha256-8vEO9EYJa8d8bQUT6nzrilk5jVEZqT9biKfHellye2c=";
    # sha256 = lib.fakeSha256;
  };

  sourceRoot = "Windsurf";

  tests = nixosTests.vscodium;

  updateScript = "nil";

  meta = with lib; {
    description = "The first agentic IDE, and then some";
  };
}
