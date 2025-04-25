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

local is_vscode = vim.g.vscode ~= nil

require("lazy").setup({
	{ "folke/which-key.nvim",   cond = not is_vscode },
	{ "EdenEast/nightfox.nvim", cond = not is_vscode },
	{
		"hrsh7th/nvim-cmp",
		cond = not is_vscode,
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
	{ "stevearc/dressing.nvim", cond = not is_vscode },
	{ "folke/flash.nvim",       cond = not is_vscode },
	{
		"folke/noice.nvim",
		cond = not is_vscode,
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
		},
	},
	{ "numToStr/Comment.nvim",   cond = not is_vscode },
	{ "nvim-tree/nvim-tree.lua", cond = not is_vscode },
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.4",
		cond = not is_vscode,
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"nvim-telescope/telescope.nvim",
		cond = not is_vscode,
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
		cond = not is_vscode,
		build =
		"cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
	},
	{ "nvim-treesitter/nvim-treesitter", cond = not is_vscode },
	{ "theHamsta/nvim-dap-virtual-text", cond = not is_vscode },
	{ "mfussenegger/nvim-dap",           cond = not is_vscode },
	{ "rcarriga/nvim-dap-ui",            cond = not is_vscode },
	{ "nvim-neotest/nvim-nio",           cond = not is_vscode },
	{ "nvim-lualine/lualine.nvim",       cond = not is_vscode },
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		cond = not is_vscode,
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{ "lewis6991/gitsigns.nvim",       cond = not is_vscode },
	{
		"lukas-reineke/indent-blankline.nvim",
		cond = not is_vscode,
		main = "ibl",
	},
	{ "simrat39/symbols-outline.nvim", cond = not is_vscode },
	{ "akinsho/toggleterm.nvim",       cond = not is_vscode },
	{ "norcalli/nvim-colorizer.lua",   cond = not is_vscode },
	{ "j-hui/fidget.nvim",             cond = not is_vscode },
	{ "GnikDroy/projections.nvim",     cond = not is_vscode },
	{ "nvim-pack/nvim-spectre",        cond = not is_vscode },
	{ "mrjones2014/legendary.nvim",    cond = not is_vscode },
	-- "rest-nvim/rest.nvim",
	{ "nvimtools/none-ls.nvim",        cond = not is_vscode },
	{ "nvim-focus/focus.nvim",         cond = not is_vscode },
	{
		"stevearc/aerial.nvim",
		cond = not is_vscode,
		opts = {},
		-- Optional dependencies
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
	},
	{
		"pmizio/typescript-tools.nvim",
		cond = not is_vscode,
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
	},
	{ "mbbill/undotree",        cond = not is_vscode },
	{ "sindrets/diffview.nvim", cond = not is_vscode },
	{
		"nvim-neotest/neotest",
		cond = not is_vscode,
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{ "nvim-neotest/neotest-jest",     cond = not is_vscode },
	{ "marilari88/neotest-vitest",     cond = not is_vscode },
	{ "nvim-neotest/neotest-vim-test", cond = not is_vscode },
	-- TODO: Replace neodev with lazydev
	{ "folke/neodev.nvim",             cond = not is_vscode, opts = {} },
	{ "windwp/nvim-autopairs",         cond = not is_vscode },
	{ "windwp/nvim-ts-autotag",        cond = not is_vscode },
	{
		"ThePrimeagen/refactoring.nvim",
		cond = not is_vscode,
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
		cond = not is_vscode,
		dependencies = {
			"mfussenegger/nvim-jdtls",
			"mfussenegger/nvim-dap",  -- for the debugger
			"rcarriga/nvim-dap-ui",   -- recommended
			"theHamsta/nvim-dap-virtual-text", -- recommended
		},
	},
	{
		"nvim-neotest/neotest",
		cond = not is_vscode,
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
