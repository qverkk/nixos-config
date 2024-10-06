_self: super: {
  neotest = super.vimUtils.buildVimPlugin {
    name = "neotest";

    src = super.fetchFromGitHub {
      owner = "nvim-neotest";
      repo = "neotest";
      rev = "6d3d22cdad49999ef774ebe1bc250a4994038964";
      sha256 = "sha256-AD1smQZ40opN557WlpwNr/PKCQ4LEs/5wjHFsEdi6oM=";
      # sha256 = super.lib.fakeSha256;
    };

    meta.homepage = "https://github.com/nvim-neotest/neotest/";
  };
}
