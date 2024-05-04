self: super: {
  nvim-nio = super.vimUtils.buildVimPlugin {
    name = "nvim-nio";

    src = super.fetchFromGitHub {
      owner = "nvim-neotest";
      repo = "nvim-nio";
      rev = "8765cbc4d0c629c8158a5341e1b4305fd93c3a90";
      sha256 = "sha256-VfoJOXXtMhalFcnfhVzweq7TVmB8WjRP+Z5Z5Z24Pzc=";
    };

    meta.homepage = "https://github.com/nvim-neotest/nvim-nio/";
  };
}
