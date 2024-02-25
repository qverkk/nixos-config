self: super: {
  neotest = super.vimUtils.buildVimPlugin {
    name = "neotest";

    src = super.fetchFromGitHub {
      owner = "nvim-neotest";
      repo = "neotest";
      rev = "f6048f32be831907fb15018af2688ff6633704fc";
      sha256 = "sha256-U9JTy5IT+kuPTlFz+L2T59Gjr42ARx/7H1wcwpu+aEU=";
    };

    meta.homepage = "https://github.com/nvim-neotest/neotest/";
  };
}
