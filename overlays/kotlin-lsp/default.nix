{
  lib,
  stdenv,
  fetchzip,
  makeWrapper,
  autoPatchelfHook,
  zlib,
  libx11,
  libxext,
  libxrender,
  libxtst,
  libxi,
  freetype,
  alsa-lib,
  wayland,
}:
stdenv.mkDerivation rec {
  pname = "kotlin-lsp";
  version = "261.13587.0";

  src = fetchzip {
    url = "https://download-cdn.jetbrains.com/kotlin-lsp/${version}/kotlin-lsp-${version}-linux-x64.zip";
    hash = "sha256-EweSqy30NJuxvlJup78O+e+JOkzvUdb6DshqAy1j9jE=";
    stripRoot = false;
  };

  dontBuild = true;

  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    zlib
    libx11
    libxext
    libxrender
    libxtst
    libxi
    freetype
    alsa-lib
    wayland
  ];

  installPhase = ''
    mkdir -p $out
    cp -r * $out/
    chmod +x $out/kotlin-lsp.sh
    find $out/jre/bin -type f -exec chmod +x {} \;
    sed -i '/chmod +x.*java/d' $out/kotlin-lsp.sh
    makeWrapper $out/kotlin-lsp.sh $out/bin/kotlin-lsp
  '';

  meta = {
    description = "kotlin language server";
    maintainers = [ ];
    homepage = "https://github.com/Kotlin/kotlin-lsp";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  };
}
