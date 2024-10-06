self: super: {
  neotest-java = super.vimUtils.buildVimPlugin {
    name = "neotest-java";

    src = super.fetchFromGitHub {
      owner = "rcasia";
      repo = "neotest-java";
      rev = "d5a31b394a989e69156fef41db286e34e34d86e3";
      sha256 = "sha256-NChDahSo3YjdF43JJXkG5TMsx9Lh/HIPAJTCvpg/Ddc=";
	  # sha256 = super.lib.fakeSha256;
    };

    meta.homepage = "https://github.com/rcasia/neotest-java";
  };
}
