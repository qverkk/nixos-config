{ }:
_self: super: {
  jdt-ls = super.callPackage ./jdt-ls { };
  codeium-lsp = super.callPackage ./codeium { };
  rofi-collection = super.callPackage ./rofi-collection { };
  gitbutler = super.callPackage ./gitbutler { };
  npm-groovy-lint = super.callPackage ./npm-groovy-lint { };
}
