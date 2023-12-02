self: super: {
  flash-nvim = super.vimUtils.buildVimPlugin {
    name = "flash.nvim";

    src = super.fetchFromGitHub {
      owner = "folke";
      repo = "flash.nvim";
      rev = "48817af25f51c0590653bbc290866e4890fe1cbe";
      sha256 = "sha256-j917u46PaOG6RmsKKoUQHuBMfXfGDD/uOBzDGhKlwTE=";
    };
    meta.homepage = "https://github.com/folke/flash.nvim";
  };
}
