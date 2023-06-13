{
  lib,
  stdenv,
  fetchFromGitHub,
  bash,
}: let
  homeDir = builtins.getEnv "HOME";
in
  stdenv.mkDerivation rec {
    name = "rofi-collection";
    rev = "0228daceb5c99f82d295f0f4711f66481ec4adc0";

    src = fetchFromGitHub {
      owner = "adi1090x";
      repo = "rofi";
      inherit rev;
      sha256 = "sha256-AYAQJivBu3NNx5M+k2Fiz20MMFnk2bq/BFm71yTpLG0=";
    };

    # After running unpackPhase, the generic builder changes the current directory
    # to the directory created by unpacking the sources. If there are multiple
    # source directories, you should set sourceRoot to the name of the intended
    # directory.
    # sourceRoot = ".";

    # requires fonts
    # GrapeNuts-Regular
    # Icomoon-Feather
    # Isoveka-Nerd-Font-Complete
    # JetBrainsMono nerd font complete

    buildInputs = [
      bash
    ];

    installPhase = ''
      THEMES_DIRECTORY=$out/share/themes

      # Copy files
      mkdir -p $THEMES_DIRECTORY
      cp -r files/* $THEMES_DIRECTORY
	  chmod -R +w $THEMES_DIRECTORY
    '';

    # cp -rf $FILES_DIR/* /home/qverkk/.config/rofi/
    # install -Dm 444 -t $FILES_DIR/* $HOME/.config/rofi

    meta = with lib; {
      homepage = "https://github.com/adi1090x/rofi";
      description = "A huge collection of Rofi based custom Applets, Launchers & Powermenus";
      license = licenses.gpl3Only;
      maintainers = with maintainers; [qverkk];
    };
  }
