_self: super: {
  neotest-java = super.vimUtils.buildVimPlugin {
    name = "neotest-java";

    src = super.fetchFromGitHub {
      owner = "rcasia";
      repo = "neotest-java";
      rev = "03c415f8bf19d5c9e17df3170e98e87e8e1353b0";
      sha256 = "sha256-dkh2WnswSDmSasXSKdqNYfGVPOwVxJ8/3St3+5owFx0=";
	  # sha256 = super.lib.fakeSha256;
    };

    meta.homepage = "https://github.com/rcasia/neotest-java";
  };
}
