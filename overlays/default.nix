{ inputs, pkgs }:
_self: super: {
  jdt-ls = super.callPackage ./jdt-ls { };
  kotlin-lsp = super.callPackage ./kotlin-lsp { };
  rofi-collection = super.callPackage ./rofi-collection { };
  npm-groovy-lint = super.callPackage ./npm-groovy-lint { };
  ghostty = inputs.ghostty.packages.${pkgs.system}.default;
  windsurf = super.callPackage ./windsurf { };
  cursor = super.callPackage ./cursor { };
  antigravity = super.callPackage ./antigravity { };
}
