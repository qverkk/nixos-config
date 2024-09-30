_self: super: {
  neotest-java = super.vimUtils.buildVimPlugin {
    name = "neotest-java";

    src = super.fetchFromGitHub {
      owner = "rcasia";
      repo = "neotest-java";
      rev = "2991ac582116bf01e4ff2e612c5e33c1b4e58fb0";
      sha256 = "sha256-xx2zsmUsbdzRw37LbEpbqlOf6Q9+XVPxffEJsWoZp3o=";
    };

    meta.homepage = "https://github.com/rcasia/neotest-java";
  };
}
