{ pkgs, inputs, ... }:
let
  languages = import ./_languages.nix { inherit pkgs; };
  providers = import ./_providers.nix;
  skills = import ./_skills.nix { inherit pkgs; };

  opencode = pkgs.opencode;

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
      plugin = [
        # "oh-my-opencode@3.0.0-beta.9"
      ];
      formatter = languages.formatter;
      lsp = languages.lsp;
      provider = providers.config;
      enabled_providers = [ "github-copilot" ];
    };
    "opencode/oh-my-opencode.json".text = builtins.toJSON {
      "$schema" =
        "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json";
      "google_auth" = false;
      "agents" = {
        "plan" = {
          "model" = "github-copilot/claude-haiku-4.5";
        };
        "build" = {
          "model" = "github-copilot/claude-sonnet-4.5";
        };
        "Planner-Sisyphus" = {
          "model" = "github-copilot/gemini-3-flash-preview";
        };
        "Sisyphus" = {
          "model" = "github-copilot/gpt-5.2";
        };
        "oracle" = {
          "model" = "github-copilot/gpt-5.2";
        };
        "explore" = {
          "model" = "github-copilot/gpt-5-mini";
        };
        "librarian" = {
          "model" = "github-copilot/gemini-3-flash-preview";
        };
        "document-writer" = {
          "model" = "github-copilot/gemini-3-flash-preview";
        };
        "multimodal-looker" = {
          "model" = "github-copilot/gemini-3-flash-preview";
        };
        "frontend-ui-ux-engineer" = {
          "model" = "github-copilot/gemini-3-pro-preview";
        };
      };
      "categories" = {
        "visual-engineering" = {
          "model" = "google/gemini-3-pro-preview";
        };
        "ultrabrain" = {
          "model" = "github-copilot/gpt-5.2-codex";
          # "variant" = "xhigh";
        };
        "artistry" = {
          "model" = "github-copilot/gemini-3-pro-preview";
          # "variant" = "max";
        };
        "quick" = {
          "model" = "github-copilot/claude-haiku-4-5";
        };
        "unspecified-low" = {
          "model" = "github-copilot/claude-sonnet-4-5";
        };
        "unspecified-high" = {
          "model" = "github-copilot/claude-opus-4-5";
          # "variant" = "max";
        };
        "writing" = {
          "model" = "github-copilot/gemini-3-flash-preview";
        };
      };
    };
    "opencode/skill".source = skills.skillsSource + "/skill";
  };
}
