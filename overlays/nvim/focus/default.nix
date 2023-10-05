self: super: {
  focus-nvim = super.vimUtils.buildVimPluginFrom2Nix {
    name = "focus.nvim";

    src = super.fetchFromGitHub {
      owner = "nvim-focus";
      repo = "focus.nvim";
      rev = "c83be53de558f6f0824c8cefcad61719c87ce157";
      sha256 = "sha256-ie4Z/WhUj8nthf7XbVFqeS4YJ1u6kLrWTuM67mRXv28=";
    };
    meta.homepage = "https://github.com/nvim-focus/focus.nvim";
  };
}
