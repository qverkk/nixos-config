self: super: {
  nvim-nio = super.vimUtils.buildVimPlugin {
    name = "nvim-nio";

    src = super.fetchFromGitHub {
      owner = "nvim-neotest";
      repo = "nvim-nio";
      rev = "33c62b3eadd8154169e42144de16ba4db6784bec";
      sha256 = "sha256-MHCrUisx3blgHWFyA5IHcSwKvC1tK1Pgy/jADBkoXX0=";
    };

    meta.homepage = "https://github.com/nvim-neotest/nvim-nio/";
  };
}
