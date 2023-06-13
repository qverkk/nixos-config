{}: self: super: {
  jdt-ls = super.callPackage ./jdt-ls {};
  rofi-collection = super.callPackage ./rofi-collection {};
}
