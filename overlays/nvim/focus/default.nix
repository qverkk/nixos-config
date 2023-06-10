self: super: {
  focus-nvim = super.vimUtils.buildVimPluginFrom2Nix {
    name = "focus.nvim";

    src = super.fetchFromGitHub {
      owner = "nvim-focus";
      repo = "focus.nvim";
      rev = "3d9df42aa4f9b572348418207b752f81adea09a5";
      sha256 = "sha256-MpGDxBJ0IMMAIxuzFkxIgKtAn56NvpjfTNMVhnBhhsE=";
    };
    meta.homepage = "https://github.com/nvim-focus/focus.nvim";
  };
}
