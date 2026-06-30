{
  lib,
  stdenv,
  buildNpmPackage,
  fetchzip,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  bubblewrap,
  patchelf,
  procps,
  socat,
}:
let
  version = "2.1.196";

  # The native binary is shipped as a separate optional npm package per platform.
  # postinstall (install.cjs) normally copies it to bin/claude.exe — we do it manually.
  nativeBin = fetchzip {
    url = "https://registry.npmjs.org/@anthropic-ai/claude-code-linux-x64/-/claude-code-linux-x64-${version}.tgz";
    hash = "sha256-geUJ8EixCPz2af9KQGJ+zXGbQgnX2uV8y3Pe0BvLDYs=";
  };
in
buildNpmPackage {
  pname = "claude-code";
  inherit version;

  src = fetchzip {
    url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
    hash = "sha256-Yaj9JMBQA0v7UQR/+LhDk+DYn9mkk2Iy1r2z/LU0+Iw=";
  };

  nativeBuildInputs = [ patchelf ];

  npmDepsHash = "sha256-booQPN9+7PCH0O3KNNILVRQDyFwBHzqFmdGfo75ZnqA=";

  strictDeps = true;

  postPatch = ''
    cp ${./package-lock.json} package-lock.json

    # Place the native binary where postinstall (install.cjs) would have put it.
    # As of 2.1.114, cli.js is gone — the bin entry points to this native ELF binary.
    cp ${nativeBin}/claude bin/claude.exe
    chmod +x bin/claude.exe
  '';

  dontNpmBuild = true;

  env.AUTHORIZED = "1";

  postInstall = ''
    # Patch ELF interpreter for NixOS (binary ships with /lib64/ld-linux-x86-64.so.2)
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/lib/node_modules/@anthropic-ai/claude-code/bin/claude.exe

    # npm wraps the bin entry with `node`, but claude.exe is a native binary — replace it
    rm $out/bin/claude
    ln -s $out/lib/node_modules/@anthropic-ai/claude-code/bin/claude.exe $out/bin/claude

    wrapProgram $out/bin/claude \
      --set DISABLE_AUTOUPDATER 1 \
      --set DISABLE_INSTALLATION_CHECKS 1 \
      --unset DEV \
      --prefix PATH : ${
        lib.makeBinPath (
          [ procps ]
          ++ lib.optionals stdenv.hostPlatform.isLinux [
            bubblewrap
            socat
          ]
        )
      }
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Agentic coding tool that lives in your terminal, understands your codebase, and helps you code faster";
    homepage = "https://github.com/anthropics/claude-code";
    downloadPage = "https://www.npmjs.com/package/@anthropic-ai/claude-code";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      adeci
      malo
      markus1189
      omarjatoi
      xiaoxiangmoe
    ];
    mainProgram = "claude";
    platforms = [ "x86_64-linux" ];
  };
}
