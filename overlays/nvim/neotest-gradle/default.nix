_self: super: {
  neotest-gradle = super.vimUtils.buildVimPlugin {
    name = "neotest-gradle";

    src = super.fetchFromGitHub {
      owner = "weilbith";
      repo = "neotest-gradle";
      rev = "cfb5d5d7d193631fc2a60244adc78313561c5d0d";
      sha256 = "sha256-u+A9yQDSEYOGD9Bw6umoS1MnTkPE5DJSo/PtSI04Lt8=";
    };

    meta.homepage = "https://github.com/weilbith/neotest-gradle";
  };
}
