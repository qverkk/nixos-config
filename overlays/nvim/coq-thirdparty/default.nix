self: super: {
  coq-thirdparty = super.vimUtils.buildVimPlugin {
    name = "coq.thirdparty";

    src = super.fetchFromGitHub {
      owner = "ms-jpq";
      repo = "coq.thirdparty";
      rev = "f110ee91f1b2b897ab0026da347396756953ca41";
      sha256 = "sha256-zAtL+s1BbqLk/Z/8JqoExuE348GaaUbQzVybJrf+leQ=";
    };

    meta.homepage = "https://github.com/ms-jpq/coq.thirdparty/";
  };
}
