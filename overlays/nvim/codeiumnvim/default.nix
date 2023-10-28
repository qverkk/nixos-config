self: super: {
  codeium-nvim = super.vimUtils.buildVimPluginFrom2Nix {
    pname = "codeium.nvim";
    version = "2023-10-27";

    src = super.fetchFromGitHub {
      owner = "Exafunction";
      repo = "codeium.nvim";
      rev = "822e762567a0bf50b1a4e733c8c93691934d7606";
      sha256 = "sha256-dU1lYBWHqxkvbJV3B9oPeqLL0H8FkSKEqjPie+9xPgQ=";
    };

    meta.homepage = "https://github.com/Exafunction/codeium.nvim";

    # patches = [
    #   ./patches/wrap-with-steam-run.patch
    # ];
  };
}
