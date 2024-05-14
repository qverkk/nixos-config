self: super: {
  codeium-nvim = super.vimUtils.buildVimPlugin {
    pname = "codeium.nvim";
    version = "2024-05-04";

    src = super.fetchFromGitHub {
      owner = "Exafunction";
      repo = "codeium.nvim";
      # rev = "d3b88eb3aa1de6da33d325c196b8a41da2bcc825";
      # sha256 = "sha256-WqZX4PMw4raTRXUliz2cr5yZeIERLq4rjB3DUoxdWn8=";
      rev = "a070f57c0f54bd940436b94c8b679bcad5a48811";
      sha256 = "sha256-BYDaQQ7G7v5csNCl7chanPDtHA1Mll1Y8c+pQxvUWuQ=";
    };

    meta.homepage = "https://github.com/Exafunction/codeium.nvim";

    # patches = [
    #   ./patches/wrap-with-steam-run.patch
    # ];
  };
}
