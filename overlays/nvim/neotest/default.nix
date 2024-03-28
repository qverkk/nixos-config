self: super: {
  neotest = super.vimUtils.buildVimPlugin {
    name = "neotest";

    src = super.fetchFromGitHub {
      owner = "nvim-neotest";
      repo = "neotest";
      rev = "e07fe8241112274aae9947b98d255763738a1d52";
      sha256 = "sha256-gmYk83oo0414jIXGJaLuJPcE2GGh2qqKNjCif9mzmnE=";
    };

    meta.homepage = "https://github.com/nvim-neotest/neotest/";
  };
}
