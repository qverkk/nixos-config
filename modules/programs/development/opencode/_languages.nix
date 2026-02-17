{ pkgs }:
let
  formatterBins = {
    alejandra = "${pkgs.alejandra}/bin/alejandra";
    biome = "${pkgs.biome}/bin/biome";
    google-java-format = "${pkgs.google-java-format}/bin/google-java-format";
    ktlint = "${pkgs.ktlint}/bin/ktlint";
  };

  lspBins = {
    biome = "${pkgs.biome}/bin/biome";
    jdt-ls = "${pkgs.jdt-ls}/bin/jdt-ls";
    kotlin-language-server = "${pkgs.kotlin-language-server}/bin/kotlin-language-server";
    nil = "${pkgs.nil}/bin/nil";
  };
in
{
  packages = with pkgs; [
    alejandra
    biome
    google-java-format
    jdt-ls
    ktlint
    kotlin-language-server
    nil
  ];

  formatter = {
    alejandra = {
      command = [
        formatterBins.alejandra
        "-q"
      ];
      extensions = [ "nix" ];
    };
    google-java-format = {
      command = [ formatterBins.google-java-format ];
      extensions = [ "java" ];
    };
    ktlint = {
      command = [
        formatterBins.ktlint
        "--format"
      ];
      extensions = [
        "kt"
        "kts"
      ];
    };
    biome = {
      command = [
        formatterBins.biome
        "format"
        "--stdin-file-path"
      ];
      extensions = [
        "js"
        "jsx"
        "ts"
        "tsx"
      ];
    };
  };

  lsp = {
    nil = {
      command = [ lspBins.nil ];
      extensions = [ "nix" ];
    };
    jdt-ls = {
      command = [ lspBins.jdt-ls ];
      extensions = [ "java" ];
    };
    kotlin-language-server = {
      command = [ lspBins.kotlin-language-server ];
      extensions = [
        "kt"
        "kts"
      ];
    };
    biome = {
      command = [
        lspBins.biome
        "lsp-proxy"
      ];
      extensions = [
        "js"
        "jsx"
        "ts"
        "tsx"
      ];
    };
  };
}
