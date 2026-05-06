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

  version = "2.2.17";
  pname = "windsurf";

  executableName = "windsurf";
  longName = "Windsurf";
  shortName = "windsurf";

  src = fetchurl {
    url = "https://windsurf-stable.codeiumdata.com/linux-x64/stable/a65d6c4e1fd335336d7a0b601099811667e184ca/Windsurf-linux-x64-2.2.17.tar.gz";
    sha256 = "sha256-lZPeayLoUZB4gYWwM9H08a0BPDbhzHN8Npb0MPu+61Q=";
    # sha256 = lib.fakeSha256;
  };

  sourceRoot = "Windsurf";

  tests = nixosTests.vscodium;

  updateScript = "nil";

  meta = with lib; {
    description = "The first agentic IDE, and then some";
  };
}
