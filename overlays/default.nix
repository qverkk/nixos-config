{ inputs, pkgs }:
_self: super: {
  jdt-ls = super.callPackage ./jdt-ls { };
  kotlin-lsp = super.callPackage ./kotlin-lsp { };
  rofi-collection = super.callPackage ./rofi-collection { };
  npm-groovy-lint = super.callPackage ./npm-groovy-lint { };
  ghostty = inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default;
  windsurf = super.callPackage ./windsurf { };
  cursor = super.callPackage ./cursor { };
  claude-code = super.callPackage ./claude-code { };
  antigravity = super.callPackage ./antigravity { };
  opencode =
    (inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default).overrideAttrs
      (oldAttrs: {
        postPatch = (oldAttrs.postPatch or "") + ''
          substituteInPlace packages/script/src/index.ts \
            --replace-fail \
            'if (!semver.satisfies(process.versions.bun, expectedBunVersionRange)) {' \
            'if (false) {'
          mkdir -p .github
          touch .github/TEAM_MEMBERS
        '';
      });
}
