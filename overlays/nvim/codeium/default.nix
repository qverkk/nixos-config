self: super: {
  codeium-vim = super.vimUtils.buildVimPluginFrom2Nix {
    pname = "codeium.vim";
    version = "2023-10-03";

    src = super.fetchFromGitHub {
      owner = "Exafunction";
      repo = "codeium.vim";
      rev = "8bc1d192d4f93da60625664e18979a7444e196d4";
      sha256 = "sha256-SY0rTEqlrIE2/9VCxOHeIpwqrJFWfN2sHRk/tW+nZbk=";
    };

    meta.homepage = "https://github.com/Exafunction/codeium.vim/";

    patches = [
      ./patches/wrap-with-steam-run.patch
    ];
  };
}
