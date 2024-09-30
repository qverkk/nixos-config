_self: super: {
  codeium-vim = super.vimUtils.buildVimPlugin {
    pname = "codeium.vim";
    version = "2023-10-27";

    src = super.fetchFromGitHub {
      owner = "Exafunction";
      repo = "codeium.vim";
      rev = "78f32674d42dcf8e5626e105bc8fb93b6c27120b";
      sha256 = "sha256-IMGHg92T9v8q2fAsTw6tV3vY1GVf2DTVtMBjMBPYHQo=";
    };

    meta.homepage = "https://github.com/Exafunction/codeium.vim/";

    patches = [ ./patches/wrap-with-steam-run.patch ];
  };
}
