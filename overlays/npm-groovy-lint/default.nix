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
  version = "15.2.1";

  src = fetchFromGitHub {
    owner = "nvuillam";
    repo = "npm-groovy-lint";
    rev = "v${version}";
    sha256 = "sha256-qVoebuUKEi7A+KcqYzGFI/39cvLeQhcoSiB31hXrrD0=";
    # sha256 = lib.fakeSha256;
  };

  npmDepsHash = "sha256-Lvv+G2T0PUPiyphd71f4uDS1eBDqOAyACBfU0D365n0=";

  buildInputs = [ makeWrapper ];
  postFixup = ''
    wrapProgram $out/bin/npm-groovy-lint --add-flags "--javaexecutable ${jdk17}/bin/java"
  '';
}
