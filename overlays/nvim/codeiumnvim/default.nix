self: super: {
  codeium-nvim = super.vimUtils.buildVimPlugin {
    pname = "codeium.nvim";
    version = "2024-10-05";

    src = super.fetchFromGitHub {
      owner = "Exafunction";
      repo = "codeium.nvim";
      # rev = "d3b88eb3aa1de6da33d325c196b8a41da2bcc825";
      # sha256 = "sha256-WqZX4PMw4raTRXUliz2cr5yZeIERLq4rjB3DUoxdWn8=";
      rev = "17bbefff02be8fd66931f366bd4ed76a76e4a57e";
      sha256 = "sha256-AHL2qezvAAZtOP61cHtnB0RtqPej4LqtGkvXNOAESNw=";
      # sha256 = super.lib.fakeSha256;
    };

    meta.homepage = "https://github.com/Exafunction/codeium.nvim";

    # patches = [
    #   ./patches/wrap-with-steam-run.patch
    # ];
  };
}
