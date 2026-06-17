{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  autoPatchelfHook,
  unzip,
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
let
  version = "262.7569.0";
  platform =
    {
      x86_64-linux = {
        artifact = "kotlin-server-${version}.tar.gz";
        hash = "sha256-MzyyEhXizgSBcle71caTy71KmRIawQCBRgHtwfktJXA=";
      };
      aarch64-linux = {
        artifact = "kotlin-server-${version}-aarch64.tar.gz";
        hash = "sha256-+XRDRZfc1BoOfpw5c7HtmZ/FIVD7BeclgqrN49Hnn38=";
      };
      x86_64-darwin = {
        artifact = "kotlin-server-${version}.sit";
        hash = "sha256-D9wPDTRadZ5qwVIiF2edjBdfgYLqtRcFuyZ8qSauJOU=";
      };
      aarch64-darwin = {
        artifact = "kotlin-server-${version}-aarch64.sit";
        hash = "sha256-4wdrZQDbjx1A4IeoAiPsuzoUz0/SIh4DHEJKlMYJRiA=";
      };
    }
    .${stdenv.hostPlatform.system}
      or (throw "kotlin-lsp: unsupported system ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation ({
  pname = "kotlin-lsp";
  inherit version;

  src = fetchurl {
    url = "https://download-cdn.jetbrains.com/kotlin-lsp/${version}/${platform.artifact}";
    inherit (platform) hash;
  };

  dontBuild = true;

  nativeBuildInputs =
    [
      makeWrapper
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      autoPatchelfHook
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      unzip
    ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
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

  sourceRoot = "kotlin-server-${version}";

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r * $out/
    chmod +x $out/bin/intellij-server
    if [ -d "$out/jbr/bin" ]; then
      find $out/jbr/bin -type f -exec chmod +x {} \;
    fi
    if [ -d "$out/jbr/Contents/Home/bin" ]; then
      find $out/jbr/Contents/Home/bin -type f -exec chmod +x {} \;
    fi
    if [ -d "$out/lib/pty4j" ]; then
      find $out/lib/pty4j -type f -exec chmod +x {} \;
    fi
    makeWrapper $out/bin/intellij-server $out/bin/kotlin-lsp

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Official Kotlin Language Server from JetBrains";
    maintainers = [ ];
    homepage = "https://github.com/Kotlin/kotlin-lsp";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "kotlin-lsp";
  };
} // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
  unpackPhase = ''
    runHook preUnpack

    unzip "$src"

    runHook postUnpack
  '';
})
