self: super: {
  flash-nvim = super.vimUtils.buildVimPlugin {
    name = "flash.nvim";

    src = super.fetchFromGitHub {
      owner = "folke";
      repo = "flash.nvim";
      rev = "7bb4a9c75d1e20cd24185afedeaa11681829ba23";
      sha256 = "sha256-HYKwF9MtRVsX6d5QxmSAGMWTqeFkkEDrHQA+oyoWxYE=";
    };
    meta.homepage = "https://github.com/folke/flash.nvim";
  };
}
