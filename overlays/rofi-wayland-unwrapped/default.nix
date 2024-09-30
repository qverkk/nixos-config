_self: super: {
  rofi-wayland-unwrapped = super.rofi-wayland-unwrapped.overrideAttrs (_old: rec {
    version = "812ad0277f202010c651ab308357a1bfde05065b";

    src = super.fetchFromGitHub {
      owner = "lbonn";
      repo = "rofi";
      rev = version;
      fetchSubmodules = true;
      sha256 = "sha256-NG+8bl71cro5neGiN+sngVrw90ADX1Rzwj38wuTWb3E=";
    };
  });
}
