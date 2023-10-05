self: super: {
  coq-thirdparty = super.vimUtils.buildVimPluginFrom2Nix {
    name = "coq.thirdparty";

    src = super.fetchFromGitHub {
      owner = "ms-jpq";
      repo = "coq.thirdparty";
      rev = "47a748c18d6378df7aa033527d1b56d6dec94dc5";
      sha256 = "sha256-WNibSlM/6OawInyGXZvfZ9c/aR/tz32rEX7v6DBYWmQ=";
    };

    meta.homepage = "https://github.com/ms-jpq/coq.thirdparty/";
  };
}
