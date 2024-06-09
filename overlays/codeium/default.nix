{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:
stdenv.mkDerivation rec {
  pname = "codeium-lsp";
  version = "v1.8.9";

  src = fetchurl {
    url = "https://github.com/Exafunction/codeium/releases/download/language-server-${version}/language_server_linux_x64";
    sha256 = "sha256-RySX/O1iIn6ApBZM/+lbfclt3mT2W8eQN86al0gx3OU=";
    # sha256 = lib.fakeSha256;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    stdenv.cc.cc
  ];

  installPhase = ''
    mkdir -p $out/bin
    install -m755 $src $out/bin/codeium-lsp
  '';

  phases = ["installPhase" "fixupPhase"];
}
