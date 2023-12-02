self: super: {
  focus-nvim = super.vimUtils.buildVimPlugin {
    name = "focus.nvim";

    src = super.fetchFromGitHub {
      owner = "nvim-focus";
      repo = "focus.nvim";
      rev = "5269ea70e2003d9dac199584b093323752a472ba";
      sha256 = "sha256-EL4mzBYxTcd3zMN8HhGOew06eK3bUVsFE7Gm8Jioirs=";
    };
    meta.homepage = "https://github.com/nvim-focus/focus.nvim";
  };
}
