_self: super: {
  typescript-tools-nvim = super.vimUtils.buildVimPlugin {
    name = "typescript-tools.nvim";

    src = super.fetchFromGitHub {
      owner = "pmizio";
      repo = "typescript-tools.nvim";
      rev = "35e397ce467bedbbbb5bfcd0aa79727b59a08d4a";
      sha256 = "sha256-x32NzZYFK6yovlvE3W8NevYA0UT0qvwKle1irFwmuvM=";
	  # sha256 = super.lib.fakeSha256;
    };
    meta.homepage = "https://github.com/pmizio/typescript-tools.nvim";
  };
}
