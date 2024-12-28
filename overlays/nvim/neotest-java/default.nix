_self: super: {
  neotest-java = super.vimUtils.buildVimPlugin {
    name = "neotest-java";

    src = super.fetchFromGitHub {
      owner = "rcasia";
      repo = "neotest-java";
      rev = "43b4cf9ee0d3d05f56a9a43c89c4268157cfbc79";
      sha256 = "sha256-HrssZbk/FI2C49kJwr4wKAYVucdEfdfQsBVltk53oxg=";
	  # sha256 = super.lib.fakeSha256;
    };

    meta.homepage = "https://github.com/rcasia/neotest-java";
  };
}
