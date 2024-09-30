_self: super: {
  neotest-vim-test = super.vimUtils.buildVimPlugin {
    name = "neotest-vim-test";

    src = super.fetchFromGitHub {
      owner = "nvim-neotest";
      repo = "neotest-vim-test";
      rev = "75c4228882ae4883b11bfce9b8383e637eb44192";
      sha256 = "sha256-fFm5Yt2Sus5jLSapHUtLlDkBWPLLKfWsj2NSXD8NPYo=";
    };

    meta.homepage = "https://github.com/nvim-neotest/neotest-vim-test";
  };
}
