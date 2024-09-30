_self: super: {
  flash-nvim = super.vimUtils.buildVimPlugin {
    name = "flash.nvim";

    src = super.fetchFromGitHub {
      owner = "folke";
      repo = "flash.nvim";
      rev = "43f67935d388fbb540f8b40e8cbfd80de54f978a";
      sha256 = "sha256-W9QB0zR7Bl7zvL0s34YmjEuKK2jDBoG9BNXiRqZnZ0U=";
    };
    meta.homepage = "https://github.com/folke/flash.nvim";
  };
}
