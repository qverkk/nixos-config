self: super: {
  rofi-wayland-unwrapped = super.rofi-wayland-unwrapped.overrideAttrs (old: rec {
    version = "c6b4dfe";

    src = super.fetchFromGitHub {
      owner = "lbonn";
      repo = "rofi";
      rev = version;
      fetchSubmodules = true;
      sha256 = "sha256-7eMW4qdrGUUgeFI3ZueXCMMK1bCkeqrYDRunnZpUt3Y=";
    };
  });
}
