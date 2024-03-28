self: super: {
  typescript-tools-nvim = super.vimUtils.buildVimPlugin {
    name = "typescript-tools.nvim";

    src = super.fetchFromGitHub {
      owner = "pmizio";
      repo = "typescript-tools.nvim";
      rev = "c43d9580c3ff5999a1eabca849f807ab33787ea7";
      sha256 = "sha256-kpdDYVd6uSuJImS9LU5p/vJgtj9tToNBvRTJHpsHyak=";
    };
    meta.homepage = "https://github.com/pmizio/typescript-tools.nvim";
  };
}
