{ pkgs, lib, ... }:

## Thanks ernestre
## https://github.com/ernestre/dotfiles/blob/master/nixpkgs/home-manager/modules/neovim/default.nix

let
  plugin = repo: rev: pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = rev;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      ref = "master";
      rev = rev;
    };
  };
in
{
  home.file.".config/nvim".source = ./config/nvim;

  home.sessionVariables = {
    JAVA_TEST_DIR = "${pkgs.vscode-extensions.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test/server/*.jar";
    JAVA_DEBUG_DIR = "${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug/server/com.microsoft.java.debug.plugin-*.jar";
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    withNodeJs = true;

    extraPackages = with pkgs; [
      # language specific colors
      tree-sitter

      # typescript
      nodePackages.typescript
      nodePackages.typescript-language-server

      # docker
      nodePackages.dockerfile-language-server-nodejs

      # lua
      sumneko-lua-language-server

      # kotlin
      kotlin-language-server

      # nix
      rnix-lsp

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
      # blazing fast buffer switching
      (plugin "ThePrimeagen/harpoon" "f4aff5bf9b512f5a85fe20eb1dcf4a87e512d971")

      # git
      gv-vim # commit browser, maybe replace this with lazygit? Atm it's laggy due to nightfox
      vim-fugitive
      gitsigns-nvim
      diffview-nvim

      # cmp
      cmp-buffer
      cmp-calc
      cmp-nvim-lsp
      cmp_luasnip
      cmp-path
      cmp-cmdline
      nvim-cmp

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
      impatient-nvim # needs setting up? TODO

      # terminal
      toggleterm-nvim

      # dap
      nvim-dap
      nvim-dap-ui
      nvim-dap-virtual-text
      telescope-dap-nvim

      #java
      nvim-jdtls
      vim-test

      #snippets
      vim-vsnip
      cmp-vsnip
      luasnip
      vim-snippets

      # themes
      gruvbox
      nightfox-nvim
      nvim-web-devicons

      # lsp
      nvim-lspconfig
      symbols-outline-nvim
      trouble-nvim
      vim-surround
      fidget-nvim

      # telescope
      plenary-nvim
      telescope-fzf-native-nvim
      telescope-fzf-writer-nvim
      telescope-nvim
      telescope-live-grep-args-nvim
      telescope-ui-select-nvim
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: [
        plugins.tree-sitter-javascript
        plugins.tree-sitter-jsdoc
        plugins.tree-sitter-json
        plugins.tree-sitter-nix
        plugins.tree-sitter-lua
        plugins.tree-sitter-help
        plugins.tree-sitter-typescript
        plugins.tree-sitter-rust
        plugins.tree-sitter-java
        plugins.tree-sitter-kotlin
      ]))
    ];
  };
}
