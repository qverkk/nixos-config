self: super: {
  flash-nvim = super.vimUtils.buildVimPluginFrom2Nix {
    name = "flash.nvim";

    src = super.fetchFromGitHub {
      owner = "folke";
      repo = "flash.nvim";
      rev = "ab7b03e5e098de59689d1478b6fea8202d0204ab";
      sha256 = "sha256-5NYcWg/5PlJL4gsU+PeihmBYWeLAdLnWbdI0ZZ9g2iM=";
    };
    meta.homepage = "https://github.com/folke/flash.nvim";
  };
}
