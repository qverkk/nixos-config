_self: super: {
  neotest-java = super.vimUtils.buildVimPlugin {
    name = "neotest-java";

    src = super.fetchFromGitHub {
      owner = "rcasia";
      repo = "neotest-java";
      rev = "c73d1d8f17aab973a7fad2e159645fe0df3f40eb";
      sha256 = "sha256-zzGiz+XgckgXSU+dTJCPQCbavJmGEdr2W9qKOCO4Jlg=";
	  # sha256 = super.lib.fakeSha256;
    };

    meta.homepage = "https://github.com/rcasia/neotest-java";
  };
}
