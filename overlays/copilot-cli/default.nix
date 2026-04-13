{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  cacert,
  nodejs_24,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "copilot-cli";
  version = "1.0.25";

  src = fetchurl {
    url = "https://registry.npmjs.org/@github/copilot/-/copilot-${finalAttrs.version}.tgz";
    hash = "sha256-z7tdCCFsGMJ09jEkdjoNUhQtL0oItlzI5Tuiw2nxVQs=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/${finalAttrs.pname}
    cp -r . $out/lib/${finalAttrs.pname}

    mkdir -p $out/bin
    makeWrapper ${lib.getExe nodejs_24} $out/bin/copilot \
      --add-flags "$out/lib/${finalAttrs.pname}/index.js" \
      --set SSL_CERT_DIR "${cacert}/etc/ssl/certs"

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "--version" ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "GitHub Copilot CLI — Copilot coding agent in your terminal";
    homepage = "https://github.com/github/copilot-cli";
    changelog = "https://github.com/github/copilot-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "copilot";
  };
})
