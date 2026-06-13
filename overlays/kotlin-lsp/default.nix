{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  autoPatchelfHook,
  zlib,
  libx11,
  libxext,
  libxrender,
  libxtst,
  libxi,
  libxkbcommon,
  freetype,
  alsa-lib,
  wayland,
}:
stdenv.mkDerivation rec {
  pname = "kotlin-lsp";
  version = "262.7569.0";

  src = fetchurl {
    url = "https://download-cdn.jetbrains.com/kotlin-lsp/${version}/kotlin-server-${version}.tar.gz";
    hash = "sha256-MzyyEhXizgSBcle71caTy71KmRIawQCBRgHtwfktJXA=";
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
    libxkbcommon
    freetype
    alsa-lib
    wayland
  ];

  installPhase = ''
    mkdir -p $out
    cp -r * $out/
    chmod +x $out/bin/intellij-server
    find $out/jbr/bin -type f -exec chmod +x {} \;
    makeWrapper $out/bin/intellij-server $out/bin/kotlin-lsp
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Official Kotlin Language Server from JetBrains";
    maintainers = [ ];
    homepage = "https://github.com/Kotlin/kotlin-lsp";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "kotlin-lsp";
  };
}
