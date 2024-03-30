{ lib
, stdenv
, fetchurl
, autoPatchelfHook
,
}:
stdenv.mkDerivation rec {
  pname = "codeium-lsp";
  version = "v1.6.7";

  src = fetchurl {
    url = "https://github.com/Exafunction/codeium/releases/download/language-server-${version}/language_server_linux_x64";
    sha256 = "sha256-tnhfo84pUiiptPvyP0NKXkSiETedH7An1NAqbwI5Wvg=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    stdenv.cc.cc
  ];

  installPhase = ''
    mkdir -p $out/bin
    install -m755 $src $out/bin/codeium-lsp
  '';

  phases = [ "installPhase" "fixupPhase" ];
}
