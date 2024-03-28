self: super: {
  focus-nvim = super.vimUtils.buildVimPlugin {
    name = "focus.nvim";

    src = super.fetchFromGitHub {
      owner = "nvim-focus";
      repo = "focus.nvim";
      rev = "c9bc6a969c3ff0d682f389129961c9e71ff2c918";
      sha256 = "sha256-Ak9NZhsPJTZGrxM3jjA5oYMKEsx2uj/Hi/KjGCDFBrI=";
    };
    meta.homepage = "https://github.com/nvim-focus/focus.nvim";
  };
}
