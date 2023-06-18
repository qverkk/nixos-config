self: super: {
  codeium-vim = super.vimUtils.buildVimPluginFrom2Nix {
    pname = "codeium.vim";
    version = "2023-06-15";

    src = super.fetchFromGitHub {
      owner = "Exafunction";
      repo = "codeium.vim";
      rev = "99714b06b85e79d9247066f7612e9cc55458bcf1";
      sha256 = "0g629r1103dxjzpi906xswkp5vilhkgyjz66avvm6m5j64xs5f8w";
    };

    meta.homepage = "https://github.com/Exafunction/codeium.vim/";

    patches = [
      ./patches/wrap-with-steam-run.patch
    ];
  };
}
