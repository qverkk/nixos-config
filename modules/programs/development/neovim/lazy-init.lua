-- move this file to .config/nvim and rename it to init.lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	"folke/which-key.nvim",
	"EdenEast/nightfox.nvim",
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/vim-vsnip",
			"hrsh7th/cmp-vsnip",
			"L3MON4D3/LuaSnip",
			"honza/vim-snippets",
			"rafamadriz/friendly-snippets",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-calc",
			"hrsh7th/cmp-nvim-lsp",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
		},
	},
	"stevearc/dressing.nvim",
	"folke/flash.nvim",
	{
		"folke/noice.nvim",
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
		},
	},
	"numToStr/Comment.nvim",
	"nvim-tree/nvim-tree.lua",
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.4",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{
				"nvim-telescope/telescope-live-grep-args.nvim",
				-- This will not install any breaking changes.
				-- For major updates, this must be adjusted manually.
				version = "^1.0.0",
			},
		},
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
	},
	"nvim-treesitter/nvim-treesitter",
	"theHamsta/nvim-dap-virtual-text",
	"mfussenegger/nvim-dap",
	"rcarriga/nvim-dap-ui",
	"nvim-neotest/nvim-nio",
	"nvim-lualine/lualine.nvim",
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	"lewis6991/gitsigns.nvim",
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl" },
	"simrat39/symbols-outline.nvim",
	"akinsho/toggleterm.nvim",
	"norcalli/nvim-colorizer.lua",
	"j-hui/fidget.nvim",
	"GnikDroy/projections.nvim",
	"nvim-pack/nvim-spectre",
	"mrjones2014/legendary.nvim",
	-- "rest-nvim/rest.nvim",
	"jose-elias-alvarez/null-ls.nvim",
	"nvim-focus/focus.nvim",
	{
		"stevearc/aerial.nvim",
		opts = {},
		-- Optional dependencies
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
	},
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
	},
	"mbbill/undotree",
	"sindrets/diffview.nvim",
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	},
	"nvim-neotest/neotest-jest",
	"marilari88/neotest-vitest",
	"nvim-neotest/neotest-vim-test",
	{ "folke/neodev.nvim", opts = {} },
	"windwp/nvim-autopairs",
	"windwp/nvim-ts-autotag",
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		lazy = false,
		config = function()
			require("refactoring").setup()
		end,
	},
	{
		"rcasia/neotest-java",
		ft = "java",
		dependencies = {
			"mfussenegger/nvim-jdtls",
			"mfussenegger/nvim-dap", -- for the debugger
			"rcarriga/nvim-dap-ui", -- recommended
			"theHamsta/nvim-dap-virtual-text", -- recommended
		},
	},
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			adapters = {
				["neotest-java"] = {
					-- config here
				},
			},
		},
	},
})

require("qverkk")
