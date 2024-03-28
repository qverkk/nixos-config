self: super: {
  codeium-nvim = super.vimUtils.buildVimPlugin {
    pname = "codeium.nvim";
    version = "2023-10-27";

    src = super.fetchFromGitHub {
      owner = "Exafunction";
      repo = "codeium.nvim";
      rev = "a070f57c0f54bd940436b94c8b679bcad5a48811";
      sha256 = "sha256-BYDaQQ7G7v5csNCl7chanPDtHA1Mll1Y8c+pQxvUWuQ=";
    };

    meta.homepage = "https://github.com/Exafunction/codeium.nvim";

    # patches = [
    #   ./patches/wrap-with-steam-run.patch
    # ];
  };
}
