self: super: {
  neotest-java = super.vimUtils.buildVimPlugin {
    name = "neotest-java";

    src = super.fetchFromGitHub {
      owner = "rcasia";
      repo = "neotest-java";
      rev = "311acc2855cc76917f59f5c534d55e5c91e26810";
      sha256 = "sha256-LmOarklYI63W8kd8VCp6PAmmfESEpqBokwebb3BrED8=";
    };

    meta.homepage = "https://github.com/rcasia/neotest-java";
  };
}
