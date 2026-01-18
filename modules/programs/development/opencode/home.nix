{ pkgs, inputs, ... }:
let
  languages = import ./_languages.nix { inherit pkgs; };
  providers = import ./_providers.nix;
  skills = import ./_skills.nix { inherit pkgs; };

  opencode = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;

  opencodeEnv = pkgs.buildEnv {
    name = "opencode-env";
    paths = languages.packages ++ skills.packages;
  };

  opencodeInitScript = pkgs.writeShellScript "opencode-init" ''
    mkdir -p "$HOME/.local/cache/opencode/node_modules/@opencode-ai"
    mkdir -p "$HOME/.config/opencode/node_modules/@opencode-ai"
    if [ -d "$HOME/.config/opencode/node_modules/@opencode-ai/plugin" ]; then
      if [ ! -L "$HOME/.local/cache/opencode/node_modules/@opencode-ai/plugin" ]; then
        ln -sf "$HOME/.config/opencode/node_modules/@opencode-ai/plugin" \
               "$HOME/.local/cache/opencode/node_modules/@opencode-ai/plugin"
      fi
    fi
    exec ${opencode}/bin/opencode "$@"
  '';

  opencodeWrapped =
    pkgs.runCommand "opencode-wrapped"
      {
        buildInputs = [ pkgs.makeWrapper ];
      }
      ''
        mkdir -p $out/bin
        makeWrapper ${opencodeInitScript} $out/bin/opencode \
          --prefix PATH : ${opencodeEnv}/bin \
          --set OPENCODE_LIBC ${pkgs.glibc}/lib/libc.so.6
      '';

  configFile = "opencode/config.json";
in
{
  home.packages = [ opencodeWrapped ];

  xdg.configFile = {
    "${configFile}".text = builtins.toJSON {
      "$schema" = "https://opencode.ai/config.json";
      plugin = [ "oh-my-opencode@3.0.0-beta.9" ];
      formatter = languages.formatter;
      lsp = languages.lsp;
      provider = providers.config;
    };
    "opencode/oh-my-opencode.json".text = builtins.toJSON {
      "$schema" =
        "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json";
    };
    "opencode/skill".source = skills.skillsSource + "/skill";
  };
}
