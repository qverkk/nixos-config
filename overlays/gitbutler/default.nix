{
  # appimageTools,
  stdenv,
  lib,
  pkgs,
  fetchurl,
  ...
}:
# https://github.com/Lenivaya/dotfiles/blob/master/packages/gitbutler.nix
# https://github.com/PHSix/nix-config/blob/42c96b5e45cdb9aefb2a055ea2826259aad5faeb/pkgs/git-butler.nix
stdenv.mkDerivation rec {
  pname = "git-butler";
  version = "0.12.2";

  src = fetchurl {
    # url = "https://releases.gitbutler.com/releases/release/${version}-713/linux/x86_64/git-butler_${version}_amd64.deb";
    url = "https://releases.gitbutler.com/releases/release/0.12.2-980/linux/x86_64/git-butler_0.12.2_amd64.deb";
    sha256 = "sha256-su0YD/LR0YVckI0LwzyFlgwBvhYn83nCVQu07nWJ00c=";
    # sha256 = lib.fakeSha256;
  };

  nativeBuildInputs = with pkgs; [
    dpkg
    wrapGAppsHook
    autoPatchelfHook
    tree
  ];

  buildInputs = with pkgs; [
    openssl
    webkitgtk
    glib-networking
    libsoup
    libthai
    stdenv.cc.cc
  ];

  installPhase = ''
    runHook preInstall
    tree

    mkdir -p $out
    mv usr/* $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "A Git client for simultaneous branches on top of your existing workflow.";
    homepage = "https://gitbutler.com/";
    platforms = [ "x86_64-linux" ];
    license = licenses.mit;
    mainProgram = "git-butler";
  };
}
