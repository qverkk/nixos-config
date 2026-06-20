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
(buildVscode {
  inherit commandLineArgs;
  useVSCodeRipgrep = false;

  version = "3.2.23";
  vscodeVersion = "1.110.1";
  pname = "windsurf";

  executableName = "windsurf";
  sourceExecutableName = "devin-desktop";
  longName = "Devin";
  shortName = "devin-desktop";

  src = fetchurl {
    url = "https://windsurf-stable.codeiumdata.com/linux-x64/stable/3bd47f77998b2e526fed61a11015b78d6205f295/Devin-linux-x64-3.2.23.tar.gz";
    sha256 = "sha256-wcA3NtoEJ7W2Kqy+6I1mlnDIjecok1L34dGGBPtZMpc=";
    # sha256 = lib.fakeSha256;
  };

  sourceRoot = "Devin";

  tests = nixosTests.vscodium;

  updateScript = "nil";

  meta = with lib; {
    description = "The first agentic IDE, and then some";
  };
}).overrideAttrs
  (oldAttrs: {
    postInstall = (oldAttrs.postInstall or "") + ''
      if [ -e "$out/lib/vscode/devin-desktop" ] && [ ! -e "$out/lib/vscode/windsurf" ]; then
        ln -s devin-desktop "$out/lib/vscode/windsurf"
      fi
    '';
  })
