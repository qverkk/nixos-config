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

  version = "3.0.28";
  vscodeVersion = "1.110.1";
  pname = "windsurf";

  executableName = "windsurf";
  sourceExecutableName = "devin-desktop";
  longName = "Devin";
  shortName = "devin-desktop";

  src = fetchurl {
    url = "https://windsurf-stable.codeiumdata.com/linux-x64/stable/e9f7e622f49ec544e97d0e624691d71a963ac40b/Devin-linux-x64-3.0.28.tar.gz";
    sha256 = "sha256-5U4eb9ztXWz6VRNuVT7pr0BcigSLKoUz5Bo5oL4Owdo=";
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
