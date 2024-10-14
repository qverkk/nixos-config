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
  version = "15.0.2";

  src = fetchFromGitHub {
    owner = "nvuillam";
    repo = "npm-groovy-lint";
    rev = "v${version}";
    sha256 = "sha256-WLQH+BkPl2Urih2VpcCMSM85RKEwLA/Cn/Cux98AknU=";
    # sha256 = lib.fakeSha256;
  };

  npmDepsHash = "sha256-wdclH75A8IPgjh9eimSt2OGTPZOHddU/z8Jf8lwaDlE=";

  buildInputs = [ makeWrapper ];
  postFixup = ''
    wrapProgram $out/bin/npm-groovy-lint --add-flags "--javaexecutable ${jdk17}/bin/java"
  '';
}
