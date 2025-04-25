{
  fetchFromGitHub,
  makeWrapper,
  jdk17,
  buildNpmPackage,
  lib,
  ...
}:

buildNpmPackage rec {
  pname = "npm-groovy-lint";
  version = "15.1.0";

  src = fetchFromGitHub {
    owner = "nvuillam";
    repo = "npm-groovy-lint";
    rev = "v${version}";
    sha256 = "sha256-BLR709MCzq3t9+7v4vfBzojd0tARG/pvhCxob5A7Xxk=";
    # sha256 = lib.fakeSha256;
  };

  npmDepsHash = "sha256-qvao/iJ3njcdrEXsH3jgNh0LuaAPrO2bLVOeiUdTwVM=";

  buildInputs = [ makeWrapper ];
  postFixup = ''
    wrapProgram $out/bin/npm-groovy-lint --add-flags "--javaexecutable ${jdk17}/bin/java"
  '';
}
