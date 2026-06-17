{ inputs, pkgs }:
_self: super: {
  jdt-ls = super.callPackage ./jdt-ls { };
  kotlin-lsp = super.callPackage ./kotlin-lsp { };
  rofi-collection = super.callPackage ./rofi-collection { };
  npm-groovy-lint = super.callPackage ./npm-groovy-lint { };
  ghostty = inputs.ghostty.packages.${super.stdenv.hostPlatform.system}.default;
  openspec =
    let
      base = inputs.openspec.packages.${super.stdenv.hostPlatform.system}.default;
      filterNodejs = pkg: !(super.lib.strings.hasPrefix "nodejs-20" pkg.name or "");
    in
    base.overrideAttrs (oldAttrs: {
      nativeBuildInputs = (super.lib.filter filterNodejs (oldAttrs.nativeBuildInputs or [ ])) ++ [
        super.nodejs_22
      ];
    });
  windsurf =
    if super.stdenv.hostPlatform.isLinux then super.callPackage ./windsurf { } else super.windsurf;
  cursor = super.callPackage ./cursor { };
  claude-code =
    if super.stdenv.hostPlatform.isLinux then
      super.callPackage ./claude-code { }
    else
      super.claude-code;
  codex-cli = super.callPackage ./codex-cli { };
  copilot-cli = super.callPackage ./copilot-cli { };
  antigravity = super.callPackage ./antigravity { };
  orion-browser = super.callPackage ./orion-browser { };
  rtk = super.callPackage ./rtk { };
  ccusage = inputs.ccusage.packages.${super.stdenv.hostPlatform.system}.default;
  opencode =
    let
      # --- WORKAROUND: upstream hashes.json has a wrong hash for x86_64-linux node_modules in v1.3.13.
      # Once fixed upstream, remove the workaround block below and uncomment the simple line instead.
      # Track: https://github.com/anomalyco/opencode
      #
      # SIMPLE (restore when upstream is fixed):
      # base = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;
      #
      # WORKAROUND (comment out when upstream is fixed):
      src = inputs.opencode.sourceInfo;
      rev = inputs.opencode.sourceInfo.shortRev or inputs.opencode.sourceInfo.dirtyShortRev or "dirty";
      node_modules = super.callPackage "${src}/nix/node_modules.nix" {
        inherit rev;
        hash =
          if super.stdenv.hostPlatform.isDarwin then
            "sha256-CJ8dvzGzJp5sgaNJYHwxRc1xK9bWA8zyTmDFi4wTI3o="
          else
            "sha256-Y+8gz+NfFSb4dysjho4CCaQpx012vvajnptfd3cdh/k=";
      };
      base = super.callPackage "${src}/nix/opencode.nix" { inherit node_modules; };
      # END WORKAROUND
      # base = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in
    base.overrideAttrs (oldAttrs: {
      preBuild = (oldAttrs.preBuild or "") + ''
        substituteInPlace packages/opencode/src/cli/cmd/generate.ts \
          --replace-fail 'const prettier = await import("prettier")' 'const prettier: any = { format: async (s: string) => s }' \
          --replace-fail 'const babel = await import("prettier/plugins/babel")' 'const babel = {}' \
          --replace-fail 'const estree = await import("prettier/plugins/estree")' 'const estree = {}'
      '';
      postPatch = (oldAttrs.postPatch or "") + ''
        substituteInPlace packages/script/src/index.ts \
          --replace-fail \
          'if (!semver.satisfies(process.versions.bun, expectedBunVersionRange)) {' \
          'if (false) {'
        mkdir -p .github
        touch .github/TEAM_MEMBERS
      '';
      buildPhase = ''
        runHook preBuild

        cd ./packages/opencode
        bun --bun ./script/build.ts --single --skip-install --skip-embed-web-ui
        bun --bun ./script/schema.ts schema.json

        runHook postBuild
      '';
    });
}
