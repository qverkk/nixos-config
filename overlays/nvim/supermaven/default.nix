self: super: {
  supermaven = super.vimUtils.buildVimPlugin {
    name = "supermaven.nvim";

    src = super.fetchFromGitHub {
      owner = "supermaven-inc";
      repo = "supermaven-nvim";
      rev = "aecec7090f1da456ad5683f5c6c3640c2a745dc1";
      sha256 = "sha256-dYsu16uNsbZzI7QhXV3QBkvJy+0MndfGwcb1zQi5ic0=";
	  # sha256 = super.lib.fakeSha256;
    };
    meta.homepage = "https://github.com/supermaven-inc/supermaven-nvim";
  };
}
