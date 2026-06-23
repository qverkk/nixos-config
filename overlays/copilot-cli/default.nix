{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  cacert,
  patchelf,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
let
  version = "1.0.64";

  platformPkg =
    {
      x86_64-linux = {
        package = "copilot-linux-x64";
        hash = "sha256-Ozp4J16PAjg3WDHXqyuvj+UQ3LDq3BQ8zhXXDJZIPYM=";
      };
      aarch64-linux = {
        package = "copilot-linux-arm64";
        hash = "sha256-RLuyISYgbgGQWoTEiHLGEHK519/xilid5up79eteWFI=";
      };
      x86_64-darwin = {
        package = "copilot-darwin-x64";
        hash = "sha256-fQOVRR/FAhmb7DzsX3Zok+cxbtAux7oyU7CJRtAJ8Xs=";
      };
      aarch64-darwin = {
        package = "copilot-darwin-arm64";
        hash = "sha256-CKUOfvgh1Cm6MwPp0NzGAWUYzqOScymhkValdgVw8CQ=";
      };
    }
    .${stdenv.hostPlatform.system}
      or (throw "copilot-cli: unsupported system ${stdenv.hostPlatform.system}");
in

stdenv.mkDerivation (finalAttrs: {
  pname = "copilot-cli";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/@github/${platformPkg.package}/-/${platformPkg.package}-${finalAttrs.version}.tgz";
    hash = platformPkg.hash;
  };

  nativeBuildInputs = [
    makeWrapper
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    patchelf
  ];

  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/${finalAttrs.pname}
    cp -r . $out/lib/${finalAttrs.pname}

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        $out/lib/${finalAttrs.pname}/copilot
    ''}

    mkdir -p $out/bin
    makeWrapper $out/lib/${finalAttrs.pname}/copilot $out/bin/copilot \
      --set SSL_CERT_DIR "${cacert}/etc/ssl/certs"

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgramArg = [ "--version" ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "GitHub Copilot CLI — Copilot coding agent in your terminal";
    homepage = "https://github.com/github/copilot-cli";
    changelog = "https://github.com/github/copilot-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "copilot";
  };
})
