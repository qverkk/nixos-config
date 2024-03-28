self: super: {
  neotest-java = super.vimUtils.buildVimPlugin {
    name = "neotest-java";

    src = super.fetchFromGitHub {
      owner = "rcasia";
      repo = "neotest-java";
      rev = "8d95a2bdc6840417fe1c5f6527c0f15df78c94f6";
      sha256 = "sha256-ciuQfd32pndNsFUzqWIOJEGgO5nu0YyZ4+eVUYMec9Y=";
    };

    meta.homepage = "https://github.com/rcasia/neotest-java";
  };
}
