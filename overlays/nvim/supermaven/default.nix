self: super: {
  supermaven = super.vimUtils.buildVimPlugin {
    name = "supermaven.nvim";

    src = super.fetchFromGitHub {
      owner = "supermaven-inc";
      repo = "supermaven-nvim";
      rev = "07d20fce48a5629686aefb0a7cd4b25e33947d50";
      sha256 = "sha256-1z3WKIiikQqoweReUyK5O8MWSRN5y95qcxM6qzlKMME=";
	  # sha256 = super.lib.fakeSha256;
    };
    meta.homepage = "https://github.com/supermaven-inc/supermaven-nvim";
  };
}
