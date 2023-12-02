self: super: {
  typescript-tools-nvim = super.vimUtils.buildVimPlugin {
    name = "typescript-tools.nvim";

    src = super.fetchFromGitHub {
      owner = "pmizio";
      repo = "typescript-tools.nvim";
      rev = "11f50fb66132c0bac929533b64536a8a7c490435";
      sha256 = "sha256-wQbNPTp8bpcUfrepEyUNql9tJciRuELOXW8q9NEmvIE=";
    };
    meta.homepage = "https://github.com/pmizio/typescript-tools.nvim";
  };
}
