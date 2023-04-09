local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
	execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
	execute "packadd packer.nvim"
end

local use = require("packer").use

return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	-- colors
-- 	use({
-- 		"sainnhe/gruvbox-material",
-- 		config = function()
-- 			vim.cmd("colorscheme gruvbox-material")
-- 		end,
-- 	})
-- 	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
-- 	use("lukas-reineke/indent-blankline.nvim")


	-- search
-- 	use({
-- 		"nvim-telescope/telescope.nvim",
-- 		tag = "0.1.x",
-- 		requires = {
-- 			{ "nvim-lua/plenary.nvim" },
-- 			{ "nvim-telescope/telescope-fzf-writer.nvim",    run = "make" },
-- 			{ "nvim-telescope/telescope-fzf-native.nvim",    run = "make" },
-- 			{ "nvim-telescope/telescope-live-grep-args.nvim" }
-- 		},
-- 	})

	-- telescope ui select
-- 	use("nvim-telescope/telescope-ui-select.nvim")

	-- lualine
-- 	use("nvim-lualine/lualine.nvim")

	-- tree
-- 	use("kyazdani42/nvim-tree.lua")

	-- undo
-- 	use("mbbill/undotree")

	-- commenter
-- 	use("numToStr/Comment.nvim")

	-- gitsigns
-- 	use {
-- 		'lewis6991/gitsigns.nvim',
-- 		-- tag = 'release' -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
-- 	}

	-- lsp
	use {
		'neovim/nvim-lspconfig',
		requires = {
			-- Automatically install LSPs to stdpath for neovim
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
		},
	}

	-- java lsp
	use("mfussenegger/nvim-jdtls")

	-- completion
	use {
		"hrsh7th/nvim-cmp",
		requires = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-cmdline" },

			-- snippet support
			{ "hrsh7th/cmp-vsnip" },
			{ "hrsh7th/vim-vsnip" }
		}
	}
end)
