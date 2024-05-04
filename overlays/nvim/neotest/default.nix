self: super: {
  neotest = super.vimUtils.buildVimPlugin {
    name = "neotest";

    src = super.fetchFromGitHub {
      owner = "nvim-neotest";
      repo = "neotest";
      rev = "5caac5cc235d495a2382bc2980630ef36ac87032";
      sha256 = "sha256-hIlva0jjoI6RPOyKiCvV0H/SvCJTllOtOXc4fkI1LcQ=";
    };

    meta.homepage = "https://github.com/nvim-neotest/neotest/";
  };
}
