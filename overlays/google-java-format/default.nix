self: super: {
  google-java-format = super.google-java-format.overrideAttrs (old: rec {
    pname = "google-java-format";
    version = "1.24.0";

    src = super.fetchurl {
      url = "https://github.com/google/google-java-format/releases/download/v${version}/google-java-format-${version}-all-deps.jar";
      sha256 = "sha256-gS+AX1gRJGDt8BvyAqjmHQ/R81wNT6vVQiBkB3bsV6E=";
    };
  });
}
