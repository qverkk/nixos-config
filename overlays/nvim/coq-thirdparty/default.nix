self: super: {
  coq-thirdparty = super.vimUtils.buildVimPluginFrom2Nix {
    name = "coq.thirdparty";

    src = super.fetchFromGitHub {
      owner = "ms-jpq";
      repo = "coq.thirdparty";
      rev = "813bd80f2233314aa6756ae747cc9bf41d816e49";
      sha256 = "sha256-WNibSlM/6OawInyGXZvfZ9c/aR/tz32rEX7v6DBYWmQ=";
    };

    meta.homepage = "https://github.com/ms-jpq/coq.thirdparty/";
  };
}
