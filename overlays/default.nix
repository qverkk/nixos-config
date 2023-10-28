{}: self: super: {
  jdt-ls = super.callPackage ./jdt-ls {};
  codeium-lsp = super.callPackage ./codeium {};
  rofi-collection = super.callPackage ./rofi-collection {};
}
