self: super: {
  flash-nvim = super.vimUtils.buildVimPluginFrom2Nix {
    name = "flash.nvim";

    src = super.fetchFromGitHub {
      owner = "folke";
      repo = "flash.nvim";
      rev = "a8da6ff212c1885ecde26af477207742959c67d7";
      sha256 = "sha256-8oqXMSPLNz8afHUUrgs00bcvgwU9VHJmHdKldpnN9vQ=";
    };
    meta.homepage = "https://github.com/folke/flash.nvim";
  };
}
