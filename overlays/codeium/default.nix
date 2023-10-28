{ lib
, stdenv
, fetchurl
, autoPatchelfHook
,
}:
stdenv.mkDerivation rec {
  pname = "codeium-lsp";
  version = "v1.4.5";

  src = fetchurl {
    url = "https://github.com/Exafunction/codeium/releases/download/language-server-${version}/language_server_linux_x64";
    sha256 = "sha256-zLfhEq6/0T4pj4WIj10bFN2mRcpMXRu7lgtjZ62P4nM=";
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
