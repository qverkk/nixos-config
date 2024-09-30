_self: super: {
  projections-nvim = super.vimUtils.buildVimPlugin {
    name = "projections.nvim";

    src = super.fetchFromGitHub {
      owner = "gnikdroy";
      repo = "projections.nvim";
      rev = "008de87";
      sha256 = "sha256-nJAZ0e9jWKErl1UASnPZltRdnaebt8E4hRvHI8xD48g=";
    };
    meta.homepage = "https://github.com/gnikdroy/projections.nvim";
  };
}
