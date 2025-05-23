{
  pkgs,
  lib,
  inputs,
  ...
}:
## Thanks ernestre
## https://github.com/ernestre/dotfiles/blob/master/nixpkgs/home-manager/modules/neovim/default.nix
let
  plugin =
    repo: rev: ref: sha256:
    pkgs.vimUtils.buildVimPlugin {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = rev;
      src = builtins.fetchGit {
        url = "https://github.com/${repo}.git";
        inherit ref;
        inherit rev;
      };
      inherit sha256;
    };

  lsp-enabled = lang: langconf: lib.mkIf (builtins.elem lang [ "java" ]) langconf;

in
# sg =
#   let
#     package = inputs.sg-nvim.packages.${pkgs.hostPlatform.system}.default;
#   in
#   {
#     inherit package;
#     init = pkgs.writeTextFile {
#       name = "sg.lua";
#       text = ''
#         return function()
#           package.cpath = package.cpath .. ";" .. "${package}/lib/?.so"
#         end
#       '';
#     };
#     paths = [ inputs.sg-nvim.packages.${pkgs.hostPlatform.system}.default ];
#   };
{
  home.file.".config/nvim".source = ./config/nvim;

  home.sessionVariables = {
    JAVA_TEST_DIR = "${pkgs.vscode-extensions.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test/server/*.jar";
    JAVA_DEBUG_DIR = "${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug/server/com.microsoft.java.debug.plugin-*.jar";
    CODEIUM_LSP_DIR = "${pkgs.vimPlugins.windsurf-nvim}";
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    withNodeJs = true;

    extraPackages = with pkgs; [
      # sg
      # sg.package

      # linters
      ## lua
      selene
      stylua

      ## nix
      deadnix
      statix
      # alejandra
      nixfmt-rfc-style

      ## java
      checkstyle
      google-java-format

      ## html, xml
      html-tidy

      ## Dockerfile
      hadolint

      ## Shell
      shellcheck
      beautysh

      ## rustfmt
      rustfmt

      ## toml
      taplo

      ### TODO: Possibly add this to nixpkgs
      ## groovy, jenkinsfile
      npm-groovy-lint

      # language specific colors
      tree-sitter

      # typescript
      nodePackages.typescript
      # nodePackages.typescript-language-server

      # prettier formatting
      nodePackages.prettier

      # docker
      nodePackages.dockerfile-language-server-nodejs
      docker-compose-language-service

      # lua
      lua-language-server

      # kotlin
      kotlin-language-server

      # nix
      nixd

      # Java
      jdt-ls
      vscode-extensions.vscjava.vscode-java-test
      vscode-extensions.vscjava.vscode-java-debug

      # bash
      nodePackages.bash-language-server

      # rust
      rust-analyzer
    ];
    plugins = with pkgs.vimPlugins; [
      # req
      plenary-nvim

      # blazing fast buffer switching
      # (plugin "ThePrimeagen/harpoon" "a84ab829eaf3678b586609888ef52f7779102263" "harpoon2" "")
      harpoon2

      # search commands
      legendary-nvim
      which-key-nvim

      # cody
      # sg-nvim

      # windsurf - codeium
      # windsurf-nvim
      supermaven-nvim

      # pkgs.typescript-tools-nvim
      typescript-tools-nvim
      nvim-ts-autotag

      # Search and replace
      nvim-spectre

      # project management
      projections-nvim

      # noice
      noice-nvim

      # auto resize buffers
      focus-nvim

      # navigation
      flash-nvim

      # git
      gv-vim # commit browser, maybe replace this with lazygit? Atm it's laggy due to nightfox
      vim-fugitive
      gitsigns-nvim
      diffview-nvim

      # rest client
      # rest-nvim

      # cmp
      cmp-buffer
      cmp-calc
      cmp-nvim-lsp
      cmp_luasnip
      cmp-path
      cmp-cmdline
      nvim-cmp

      # refactoring
      refactoring-nvim

      # utils
      comment-nvim
      nvim-autopairs
      lualine-nvim
      nvim-colorizer-lua
      indent-blankline-nvim
      markdown-preview-nvim
      undotree
      nvim-tree-lua
      vim-repeat

      # nvim speedup
      impatient-nvim # needs setting up?

      # terminal
      toggleterm-nvim

      # dap
      nvim-dap
      nvim-dap-ui
      nvim-dap-virtual-text
      telescope-dap-nvim

      #java
      nvim-jdtls

      # testing
      # vim-test

      # neotest
      nvim-nio
      neotest
      FixCursorHold-nvim
      neotest-java
      # pkgs.neotest-jdtls
      # pkgs.neotest-gradle
      # pkgs.neotest-vim-test
      neotest-jest
      neotest-vitest
      neodev-nvim

      #snippets
      vim-vsnip
      cmp-vsnip
      luasnip
      vim-snippets
      friendly-snippets

      # themes
      gruvbox
      nightfox-nvim
      nvim-web-devicons

      # lsp
      nvim-lspconfig
      # symbols-outline-nvim
      aerial-nvim
      trouble-nvim
      vim-surround
      fidget-nvim
      none-ls-nvim

      # telescope
      telescope-fzf-native-nvim
      telescope-fzf-writer-nvim
      telescope-nvim
      telescope-live-grep-args-nvim

      # dressing
      dressing-nvim

      (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: [
        plugins.tree-sitter-javascript
        plugins.tree-sitter-jsdoc
        plugins.tree-sitter-json
        plugins.tree-sitter-nix
        plugins.tree-sitter-lua
        plugins.tree-sitter-typescript
        plugins.tree-sitter-rust
        plugins.tree-sitter-java
        plugins.tree-sitter-kotlin
        plugins.tree-sitter-http
        plugins.tree-sitter-groovy
      ]))
    ];
  };

  programs.helix = {
    enable = true;
    # extraPackages = with pkgs; [
    #   jdt-ls
    # ];

    languages = {
      language-server.jdtls = lsp-enabled "java" {
        command = "${pkgs.jdt-ls}/bin/jdt-ls";
        # args = [
        #   "--jvm-arg=-javaagent:${pkgs.lombok}/share/java/lombok.jar"
        #   "-configuration"
        #   "${config.xdg.cacheHome}/.jdt/jdtls_install/config_linux"
        #   "-data"
        #   "${config.xdg.cacheHome}/.jdt/jdtls_data"
        # ];
      };
    };
  };
}
