{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  sqlite,
  gitMinimal,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rtk";
  version = "0.42.4";

  src = fetchFromGitHub {
    owner = "rtk-ai";
    repo = "rtk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8nLJ5PVefXmoXQyw6HERfCP06C+l4I+7XLwKFNVNpew=";
  };

  strictDeps = true;

  cargoHash = "sha256-YsKOyEZ281ojqiitnvCFGy/MzHMyr4hlxqMnvrQwguQ=";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [ sqlite ];

  postInstall = ''
    wrapProgram $out/bin/rtk \
      --prefix PATH : ${
        lib.makeBinPath [
          gitMinimal
        ]
      }
  '';

  nativeCheckInputs = [
    gitMinimal
    writableTmpDirAsHomeHook
  ];

  checkFlags = [
    # Flaky test - timing issues in Nix build environment
    "--skip=test_timed_execution_passthrough"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "CLI proxy that reduces LLM token consumption by 60-90% on common dev commands";
    homepage = "https://github.com/rtk-ai/rtk";
    changelog = "https://github.com/rtk-ai/rtk/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "rtk";
  };
})
