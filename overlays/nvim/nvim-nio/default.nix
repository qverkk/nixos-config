self: super: {
  nvim-nio = super.vimUtils.buildVimPlugin {
    name = "nvim-nio";

    src = super.fetchFromGitHub {
      owner = "nvim-neotest";
      repo = "nvim-nio";
      rev = "a428f309119086dc78dd4b19306d2d67be884eee";
      sha256 = "sha256-i6imNTb1xrfBlaeOyxyIwAZ/+o6ew9C4/z34a7/BgFg=";
      # sha256 = super.lib.fakeSha256;
    };

    meta.homepage = "https://github.com/nvim-neotest/nvim-nio/";
  };
}
