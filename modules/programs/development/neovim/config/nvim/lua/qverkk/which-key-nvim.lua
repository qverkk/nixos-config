vim.o.timeout = true
vim.o.timeoutlen = 300

local which_key = require("which-key")
local harpoon = require("harpoon")

local opts = {
	mode = "n", -- NORMAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local vopts = {
	mode = "v", -- VISUAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local harpoonopts = {
	mode = "n", -- NORMAL mode
	prefix = "<A>",
	-- buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	-- silent = true, -- use `silent` when creating keymaps
	-- noremap = true, -- use `noremap` when creating keymaps
	-- nowait = true, -- use `nowait` when creating keymaps
}

local harpoonmappings = {
	["<A-h>"] = { function() harpoon:list():select(1) end, "Harpoon file 1" },
	["<A-j>"] = { function() harpoon:list():select(2) end, "Harpoon file 2" },
	["<A-k>"] = { function() harpoon:list():select(3) end, "Harpoon file 3" },
	["<A-l>"] = { function() harpoon:list():select(4) end, "Harpoon file 4" },
}

-- NOTE: Prefer using : over <cmd> as the latter avoids going back in normal-mode.
-- see https://neovim.io/doc/user/map.html#:map-cmd
local vmappings = {
	["/"] = { "<Plug>(comment_toggle_linewise_visual)", "Comment toggle linewise (visual)" },
	l = {
		name = "LSP",
		a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
	},
}

local mappings = {
	h = {
		name = "Harpoon",
		a = { function() harpoon:list():append() end, "Harpoon add mark" },
		e = { function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, "Harpoon browse marks" },
	},
	["w"] = { "<cmd>w!<CR>", "Save" },
	["q"] = { "<cmd>confirm q<CR>", "Quit" },
	["/"] = { "<Plug>(comment_toggle_linewise_current)", "Comment toggle current line" },
	["c"] = { "<cmd>bd<CR>", "Close Buffer" },
	f = {
		name = "Find",
		f = { "<cmd>Telescope find_files<cr>", "Find files" },
		g = { "<cmd>Telescope live_grep<cr>", "Find text" },
		b = { "<cmd>Telescope buffers<cr>", "Find buffers" },
		p = { "<cmd>Telescope git_files<cr>", "Find git files" },
		P = { "<cmd>Telescope projections<cr>", "Find projects" },
		a = { "<cmd>Telescope commands<cr>", "Find commands" },
		A = { "<cmd>Legendary<cr>", "Find legendary commands" },
		l = { "<cmd>Telescope resume<cr>", "Resume last search" },
		s = { "<cmd>SymbolsOutline<cr>", "Find symbols outline" },
	},
	["e"] = { "<cmd>NvimTreeToggle<CR>", "Explorer" },
	d = {
		name = "Debug",
		t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
		T = {
			"<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>",
			"Debug conditional breakpoint",
		},
		b = { "<cmd>lua require'dap'.step_back()<cr>", "Debug step Back" },
		c = { "<cmd>lua require'dap'.continue()<cr>", "Debug continue" },
		C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Debug run To Cursor" },
		d = { "<cmd>lua require'dap'.disconnect()<cr>", "Debug disconnect" },
		g = { "<cmd>lua require'dap'.session()<cr>", "Debug get Session" },
		i = { "<cmd>lua require'dap'.step_into()<cr>", "Debug step Into" },
		o = { "<cmd>lua require'dap'.step_over()<cr>", "Debug step Over" },
		u = { "<cmd>lua require'dap'.step_out()<cr>", "Debug step Out" },
		p = { "<cmd>lua require'dap'.pause()<cr>", "Debug pause" },
		r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Debug toggle Repl" },
		s = { "<cmd>lua require'dap'.continue()<cr>", "Debug start" },
		q = { "<cmd>lua require'dap'.close()<cr>", "Debug quit" },
		U = { "<cmd>lua require'dapui'.toggle({reset = true})<cr>", "Debug toggle UI" },
		n = { "<cmd>lua _debug_nearest_method()<CR>", "Debug nearest method" },
		f = { "<cmd>lua _debug_test_class()<CR>", "Debug test class" },
	},
	g = {
		name = "Git",
		g = { "<cmd>lua _lazygit_toggle()<CR>", "Lazygit" },
		j = { "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", "Git next Hunk" },
		k = { "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", "Git prev Hunk" },
		l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Git blame" },
		p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Git preview Hunk" },
		r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Git reset Hunk" },
		R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Git reset Buffer" },
		o = { "<cmd>Telescope git_status<cr>", "Git open changed file" },
		b = { "<cmd>Telescope git_branches<cr>", "Git checkout branch" },
		c = { "<cmd>Telescope git_commits<cr>", "Git checkout commit" },
		C = {
			"<cmd>Telescope git_bcommits<cr>",
			"Checkout commit(for current file)",
		},
		d = {
			"<cmd>Gitsigns diffthis HEAD<cr>",
			"Git Diff",
		},
	},
	l = {
		name = "LSP",
		a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
		d = { "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>", "Buffer Diagnostics" },
		w = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
		f = { "<cmd>lua vim.lsp.buf.format()<cr>", "Format" },
		i = { "<cmd>LspInfo<cr>", "Info" },
		j = {
			"<cmd>lua vim.diagnostic.goto_next()<cr>",
			"Next Diagnostic",
		},
		k = {
			"<cmd>lua vim.diagnostic.goto_prev()<cr>",
			"Prev Diagnostic",
		},
		l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
		q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix" },
		r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
		s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
		S = {
			"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
			"Workspace Symbols",
		},
		e = { "<cmd>Telescope quickfix<cr>", "Telescope Quickfix" },
	},
	["u"] = { "<cmd>UndotreeToggle<CR>", "Undotree" },
	t = {
		name = "Test",
		t = { "<cmd>TestNearest<cr>", "Test nearest" },
		T = { "<cmd>TestFile<cr>", "Test file" },
		a = { "<cmd>TestSuite<cr>", "Test all" },
		l = { "<cmd>TestLast<cr>", "Test last" },
		g = { "<cmd>TestVisit<cr>", "Go to test class" },
	},
	["T"] = { "<cmd>ToggleTerm<cr>", "Toggle terminal" },
	["S"] = { "<cmd>Spectre<cr>", "Toggle spectre (find and replace)" },
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

which_key.register(mappings, opts)
which_key.register(vmappings, vopts)

-- TODO: Doesn't work, needs fixing, these don't work in legendary aswell
which_key.register(harpoonmappings, harpoonopts)
