self: super: {
  rofi-wayland-unwrapped = super.rofi-wayland-unwrapped.overrideAttrs (old: rec {
    version = "9d11a2b4a9095b3f0a092155f749900f7eb8e047";

    src = super.fetchFromGitHub {
      owner = "lbonn";
      repo = "rofi";
      rev = version;
      fetchSubmodules = true;
      sha256 = "sha256-7eMW4qdrGUUgeFI3ZueXCMMK1bCkeqrYDRunnZpUt3Y=";
    };
  });
}
