vim.o.timeout = true
vim.o.timeoutlen = 300

local which_key = require("which-key")
local harpoon = require("harpoon")

local harpoonopts = {
	mode = "n", -- NORMAL mode
	prefix = "<A>",
	-- buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	-- silent = true, -- use `silent` when creating keymaps
	-- noremap = true, -- use `noremap` when creating keymaps
	-- nowait = true, -- use `nowait` when creating keymaps
}

local harpoonmappings = {
	["<A-h>"] = {
		function()
			harpoon:list():select(1)
		end,
		"Harpoon file 1",
	},
	["<A-j>"] = {
		function()
			harpoon:list():select(2)
		end,
		"Harpoon file 2",
	},
	["<A-k>"] = {
		function()
			harpoon:list():select(3)
		end,
		"Harpoon file 3",
	},
	["<A-l>"] = {
		function()
			harpoon:list():select(4)
		end,
		"Harpoon file 4",
	},
}

-- NOTE: Prefer using : over <cmd> as the latter avoids going back in normal-mode.
-- see https://neovim.io/doc/user/map.html#:map-cmd
local vmappings = {
	mode = "v", -- VISUAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
	{
		"<leader>/",
		"<Plug>(comment_toggle_linewise_visual)",
		desc = "Comment toggle linewise (visual)",
	},
	{
		"<leader>l",
		group = "LSP",
	},
	{
		"<leader>la",
		"<cmd>lua vim.lsp.buf.code_action()<cr>",
		desc = "Code Action",
	},
	{
		"<leader>r",
		group = "Find and replace",
	},
	{
		"<leader>ro",
		"<esc>:lua require('spectre').open_visual()<cr>",
		desc = "Find under cursor",
	},
}

local mappings = {
	mode = "n",
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
	{
		"<leader>/",
		"<Plug>(comment_toggle_linewise_current)",
		desc = "Comment toggle current line",
	},
	{
		"<leader>R",
		"<cmd> lua require('telescope').extensions.refactoring.refactors()<cr>",
		desc = "Refactoring",
	},
	{
		"<leader>T",
		"<cmd>ToggleTerm<cr>",
		desc = "Toggle terminal",
	},
	{
		"<leader>a",
		group = "Aerial",
	},
	{
		"<leader>aa",
		"<cmd>AerialToggle!<CR>",
		desc = "Toggle aerial",
	},
	{
		"<leader>c",
		"<cmd>bd<CR>",
		desc = "Close Buffer",
	},
	{
		"<leader>d",
		group = "Debug",
	},
	{
		"<leader>dC",
		"<cmd>lua require'dap'.run_to_cursor()<cr>",
		desc = "Debug run To Cursor",
	},
	{
		"<leader>dT",
		"<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>",
		desc = "Debug conditional breakpoint",
	},
	{
		"<leader>dU",
		"<cmd>lua require'dapui'.toggle({reset = true})<cr>",
		desc = "Debug toggle UI",
	},
	{
		"<leader>db",
		"<cmd>lua require'dap'.step_back()<cr>",
		desc = "Debug step Back",
	},
	{
		"<leader>dc",
		"<cmd>lua require'dap'.continue()<cr>",
		desc = "Debug continue",
	},
	{
		"<leader>dd",
		"<cmd>lua require'dap'.disconnect()<cr>",
		desc = "Debug disconnect",
	},
	{
		"<leader>df",
		"<cmd>lua _debug_test_class()<CR>",
		desc = "Debug test class",
	},
	{
		"<leader>dg",
		"<cmd>lua require'dap'.session()<cr>",
		desc = "Debug get Session",
	},
	{
		"<leader>di",
		"<cmd>lua require'dap'.step_into()<cr>",
		desc = "Debug step Into",
	},
	{
		"<leader>dn",
		"<cmd>lua _debug_nearest_method()<CR>",
		desc = "Debug nearest method",
	},
	{
		"<leader>do",
		"<cmd>lua require'dap'.step_over()<cr>",
		desc = "Debug step Over",
	},
	{
		"<leader>dp",
		"<cmd>lua require'dap'.pause()<cr>",
		desc = "Debug pause",
	},
	{
		"<leader>dq",
		"<cmd>lua require'dap'.close()<cr>",
		desc = "Debug quit",
	},
	{
		"<leader>dr",
		"<cmd>lua require'dap'.repl.toggle()<cr>",
		desc = "Debug toggle Repl",
	},
	{
		"<leader>ds",
		"<cmd>lua require'dap'.continue()<cr>",
		desc = "Debug start",
	},
	{
		"<leader>dt",
		"<cmd>lua require'dap'.toggle_breakpoint()<cr>",
		desc = "Toggle Breakpoint",
	},
	{
		"<leader>du",
		"<cmd>lua require'dap'.step_out()<cr>",
		desc = "Debug step Out",
	},
	{
		"<leader>e",
		"<cmd>NvimTreeToggle<CR>",
		desc = "Explorer",
	},
	{
		"<leader>f",
		group = "Find",
	},
	{
		"<leader>fA",
		"<cmd>Legendary<cr>",
		desc = "Find legendary commands",
	},
	{
		"<leader>fP",
		"<cmd>Telescope projections<cr>",
		desc = "Find projects",
	},
	{
		"<leader>fa",
		"<cmd>Telescope commands<cr>",
		desc = "Find commands",
	},
	{
		"<leader>fb",
		"<cmd>Telescope buffers<cr>",
		desc = "Find buffers",
	},
	{
		"<leader>ff",
		"<cmd>Telescope find_files<cr>",
		desc = "Find files",
	},
	{
		"<leader>fg",
		"<cmd>Telescope live_grep<cr>",
		desc = "Find text",
	},
	{
		"<leader>fl",
		"<cmd>Telescope resume<cr>",
		desc = "Resume last search",
	},
	{
		"<leader>fp",
		"<cmd>Telescope git_files<cr>",
		desc = "Find git files",
	},
	{
		"<leader>fs",
		"<cmd>SymbolsOutline<cr>",
		desc = "Find symbols outline",
	},
	{
		"<leader>g",
		group = "Git",
	},
	{
		"<leader>gC",
		"<cmd>Telescope git_bcommits<cr>",
		desc = "Checkout commit(for current file)",
	},
	{
		"<leader>gR",
		"<cmd>lua require 'gitsigns'.reset_buffer()<cr>",
		desc = "Git reset Buffer",
	},
	{
		"<leader>gb",
		"<cmd>Telescope git_branches<cr>",
		desc = "Git checkout branch",
	},
	{
		"<leader>gc",
		"<cmd>Telescope git_commits<cr>",
		desc = "Git checkout commit",
	},
	{
		"<leader>gd",
		"<cmd>Gitsigns diffthis HEAD<cr>",
		desc = "Git Diff",
	},
	{
		"<leader>gg",
		"<cmd>lua _lazygit_toggle()<CR>",
		desc = "Lazygit",
	},
	{
		"<leader>gj",
		"<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>",
		desc = "Git next Hunk",
	},
	{
		"<leader>gk",
		"<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>",
		desc = "Git prev Hunk",
	},
	{
		"<leader>gl",
		"<cmd>lua require 'gitsigns'.blame_line()<cr>",
		desc = "Git blame",
	},
	{
		"<leader>go",
		"<cmd>Telescope git_status<cr>",
		desc = "Git open changed file",
	},
	{
		"<leader>gp",
		"<cmd>lua require 'gitsigns'.preview_hunk()<cr>",
		desc = "Git preview Hunk",
	},
	{
		"<leader>gr",
		"<cmd>lua require 'gitsigns'.reset_hunk()<cr>",
		desc = "Git reset Hunk",
	},
	{
		"<leader>h",
		group = "Harpoon",
	},
	{
		"<leader>ha",
		function()
			harpoon:list():add()
		end,
		desc = "Harpoon add mark",
	},
	{
		"<leader>he",
		function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end,
		desc = "Harpoon browse marks",
	},
	{
		"<leader>l",
		group = "LSP",
	},
	{
		"<leader>lD",
		"<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>",
		desc = "Buffer Diagnostics",
	},
	{
		"<leader>lI",
		"<cmd>LspInfo<cr>",
		desc = "Info",
	},
	{
		"<leader>lQ",
		"<cmd>lua vim.diagnostic.setloclist()<cr>",
		desc = "Quickfix",
	},
	{
		"<leader>lR",
		"<cmd>lua vim.lsp.buf.rename()<cr>",
		desc = "Rename",
	},
	{
		"<leader>lS",
		"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
		desc = "Workspace Symbols",
	},
	{
		"<leader>lW",
		"<cmd>Telescope diagnostics<cr>",
		desc = "Diagnostics",
	},
	{
		"<leader>la",
		"<cmd>lua vim.lsp.buf.code_action()<cr>",
		desc = "Code Action",
	},
	{
		"<leader>ld",
		"<cmd>:Telescope lsp_definitions<cr>",
		desc = "Definitions",
	},
	{
		"<leader>le",
		"<cmd>Telescope quickfix<cr>",
		desc = "Telescope Quickfix",
	},
	{
		"<leader>lf",
		"<cmd>lua vim.lsp.buf.format()<cr>",
		desc = "Format",
	},
	{
		"<leader>li",
		"<cmd>:Telescope lsp_implementations<cr>",
		desc = "Implementations",
	},
	{
		"<leader>lj",
		"<cmd>lua vim.diagnostic.goto_next()<cr>",
		desc = "Next Diagnostic",
	},
	{
		"<leader>lk",
		"<cmd>lua vim.diagnostic.goto_prev()<cr>",
		desc = "Prev Diagnostic",
	},
	{
		"<leader>ll",
		"<cmd>lua vim.lsp.codelens.run()<cr>",
		desc = "CodeLens Action",
	},
	{
		"<leader>lq",
		"<cmd>lua vim.lsp.buf.signature_help()<cr>",
		desc = "Signature info",
	},
	{
		"<leader>lr",
		"<cmd>:Telescope lsp_references<cr>",
		desc = "References",
	},
	{
		"<leader>ls",
		"<cmd>Telescope lsp_document_symbols<cr>",
		desc = "Document Symbols",
	},
	{
		"<leader>q",
		"<cmd>confirm q<CR>",
		desc = "Quit",
	},
	{
		"<leader>r",
		group = "Find and replace",
	},
	{
		"<leader>rf",
		"<cmd>lua require('spectre').open_file_search()<cr>",
		desc = "Find and replace - Rearch in file",
	},
	{
		"<leader>rl",
		"<cmd>lua require('spectre').resume_last_search()<cr>",
		desc = "Find and replace - Resume last search",
	},
	{
		"<leader>ro",
		"<cmd>lua require('spectre').open()<cr>",
		desc = "Find and replace - Open",
	},
	{
		"<leader>rw",
		"<cmd>lua require('spectre').open_visual({select_word=true})<cr>",
		desc = "Find and replace - Seach current word",
	},
	{
		"<leader>s",
		"<cmd>lua require('utils.treesitter-utils').goto_translation()<CR>",
		desc = "Go to translation",
	},
	{
		"<leader>t",
		group = "Test",
	},
	{
		"<leader>tF",
		"<cmd>w<cr><cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>",
		desc = "Debug File",
	},
	{
		"<leader>tL",
		"<cmd>w<cr><cmd>lua require('neotest').run.run_last({ strategy = 'dap' })<cr>",
		desc = "Debug Last",
	},
	{
		"<leader>tN",
		"<cmd>w<cr><cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>",
		desc = "Debug Nearest",
	},
	{
		"<leader>tO",
		"<cmd>lua require('neotest').output.open({ enter = true })<cr>",
		desc = "Full Output",
	},
	{
		"<leader>tS",
		"<cmd>lua require('neotest').run.stop()<cr>",
		desc = "Stop",
	},
	{
		"<leader>ta",
		"<cmd>lua require('neotest').run.attach()<cr>",
		desc = "Attach",
	},
	{
		"<leader>tf",
		"<cmd>w<cr><cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
		desc = "Run File",
	},
	{
		"<leader>tl",
		"<cmd>w<cr><cmd>lua require('neotest').run.run_last()<cr>",
		desc = "Run Last",
	},
	{
		"<leader>tn",
		"<cmd>w<cr><cmd>lua require('neotest').run.run()<cr>",
		desc = "Run Nearest",
	},
	{
		"<leader>to",
		"<cmd>lua require('neotest').output.open({ enter = true, short = true })<cr>",
		desc = "Short output",
	},
	{
		"<leader>ts",
		"<cmd>lua require('neotest').summary.open()<cr>",
		desc = "Summary",
	},
	{
		"<leader>u",
		"<cmd>UndotreeToggle<CR>",
		desc = "Undotree",
	},
	{
		"<leader>w",
		"<cmd>w!<CR>",
		desc = "Save",
	},
}

which_key.setup({
	active = true,
	on_config_done = nil,
	setup = {
		plugins = {
			marks = false, -- shows a list of your marks on ' and `
			registers = false, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
			spelling = {
				enabled = true,
				suggestions = 20,
			}, -- use which-key for spelling hints
			-- the presets plugin, adds help for a bunch of default keybindings in Neovim
			-- No actual key bindings are created
			presets = {
				operators = false, -- adds help for operators like d, y, ...
				motions = false, -- adds help for motions
				text_objects = false, -- help for text objects triggered after entering an operator
				windows = false, -- default bindings on <c-w>
				nav = false, -- misc bindings to work with windows
				z = false, -- bindings for folds, spelling and others prefixed with z
				g = false, -- bindings for prefixed with g
			},
		},
		-- add operators that will trigger motion and text object completion
		-- to enable all native operators, set the preset / operators plugin above
		operators = { gc = "Comments" },
		key_labels = {
			-- override the label used to display some keys. It doesn't effect WK in any other way.
			-- For example:
			-- ["<space>"] = "SPC",
			-- ["<cr>"] = "RET",
			-- ["<tab>"] = "TAB",
		},
		window = {
			border = "single", -- none, single, double, shadow
			position = "bottom", -- bottom, top
			margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
			padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
			winblend = 0,
		},
		layout = {
			height = { min = 4, max = 25 }, -- min and max height of the columns
			width = { min = 20, max = 50 }, -- min and max width of the columns
			spacing = 3, -- spacing between columns
			align = "left", -- align columns left, center or right
		},
		ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
		hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
		show_help = true, -- show help message on the command line when the popup is visible
		show_keys = true, -- show the currently pressed key and its label as a message in the command line
		triggers = "auto", -- automatically setup triggers
		-- triggers = {"<leader>"} -- or specify a list manually
		triggers_blacklist = {
			-- list of mode / prefixes that should never be hooked by WhichKey
			-- this is mostly relevant for key maps that start with a native binding
			-- most people should not need to change this
			i = { "j", "k" },
			v = { "j", "k" },
		},
		-- disable the WhichKey popup for certain buf types and file types.
		-- Disabled by default for Telescope
		disable = {
			buftypes = {},
			filetypes = { "TelescopePrompt" },
		},
	},
})

function _G.http_mappings()
	local buffKeymap = {
		e = { "<Plug>RestNvim", "Execute" },
		p = { "<Plug>RestNvimPreview", "Preview" },
		l = { "<Plug>RestNvimLast", "Re-run last" },
	}

	which_key.register(buffKeymap, { prefix = "<localleader>", buffer = 0 })
end

function _G.typescript_mappings()
	local buffKeymap = {
		i = {
			name = "Typescript tools",
			r = { "<cmd>TSToolsRenameFile<CR>", "Rename file" },
			a = { "<cmd>TSToolsAddMissingImports sync<CR>", "Add missing imports" },
			o = { "<cmd>TSToolsOrganizeImports sync<CR>", "Organize imports" },
			u = { "<cmd>TSToolsRemoveUnusedImports sync<CR>", "Remove unused" },
			f = { "<cmd>TSToolsFixAll sync<CR>", "Fix all problems" },
		},
	}

	which_key.register(buffKeymap, opts)
end

which_key.add(mappings)
which_key.register(vmappings, vopts)

-- TODO: Doesn't work, needs fixing, these don't work in legendary aswell
-- which_key.register(harpoonmappings, harpoonopts)
