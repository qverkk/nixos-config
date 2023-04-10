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

  programs.neovim = {
    enable = true;
    vimAlias = true;
    withNodeJs = true;

    extraPackages = with pkgs; [
      tree-sitter
      nodePackages.typescript
      nodePackages.typescript-language-server
      rnix-lsp
      sumneko-lua-language-server
      nodePackages.pyright
      kotlin-language-server
      jdt-ls
    ];
    plugins = with pkgs.vimPlugins; [
      (plugin "ThePrimeagen/harpoon" "f4aff5bf9b512f5a85fe20eb1dcf4a87e512d971")
      cmp-buffer
      cmp-calc
      cmp-nvim-lsp
      cmp-nvim-ultisnips
      cmp-path
      comment-nvim
      committia-vim
      gitsigns-nvim
      gv-vim
      impatient-nvim
      indent-blankline-nvim
      lspkind-nvim
      lualine-nvim
      markdown-preview-nvim
      mkdir-nvim
      nvim-autopairs
      nvim-cmp
      nvim-colorizer-lua

      # dap
      nvim-dap
      nvim-dap-go
      nvim-dap-ui
      nvim-dap-virtual-text
      telescope-dap-nvim

      #java
      nvim-jdtls

	  #snippets
	  vim-vsnip
	  cmp-vsnip

      nvim-lspconfig
      nvim-tree-lua
      nvim-web-devicons
      plenary-nvim
      popup-nvim
      gruvbox
      symbols-outline-nvim
      telescope-fzf-native-nvim
      telescope-fzf-writer-nvim
      telescope-nvim
      telescope-live-grep-args-nvim
      telescope-ui-select-nvim
      ultisnips
      undotree
      vim-fugitive
      vim-repeat
      vim-snippets
      vim-surround
      vimwiki
      diffview-nvim
      gitlinker-nvim
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
