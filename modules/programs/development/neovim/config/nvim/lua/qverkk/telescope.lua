local setup, plugin = pcall(require, "telescope")
if not setup then
	return
end

local lga_actions = require("telescope-live-grep-args.actions")

-- This is your opts table
plugin.setup({
	pickers = {
		buffers = {
			show_all_buffers = true,
			sort_mru = true,
			mappings = {
				i = {
					["<c-d>"] = "delete_buffer",
				},
			},
		},
	},

	fzf = {
		fuzzy = true, -- false will only do exact matching
		override_generic_sorter = true, -- override the generic sorter
		override_file_sorter = true, -- override the file sorter
		case_mode = "smart_case", -- or "ignore_case" or "respect_case"
	},

	live_grep_args = {
		auto_quoting = true, -- enable/disable auto-quoting
		-- define mappings, e.g.
		mappings = {
			-- extend mappings
			i = {
				["<C-k>"] = lga_actions.quote_prompt(),
				["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
			},
		},
	},
})

require("telescope").load_extension("fzf")
