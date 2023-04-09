local builtin = require("telescope.builtin")
local lga_actions = require("telescope-live-grep-args.actions")

vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fp", builtin.git_files, {})

-- This is your opts table
require("telescope").setup({
	fzf = {
		fuzzy = true, -- false will only do exact matching
		override_generic_sorter = true, -- override the generic sorter
		override_file_sorter = true, -- override the file sorter
		case_mode = "smart_case", -- or "ignore_case" or "respect_case"
	},

	live_grep_args = {
		auto_quoting = true, -- enable/disable auto-quoting
		-- define mappings, e.g.
		mappings = { -- extend mappings
			i = {
				["<C-k>"] = lga_actions.quote_prompt(),
				["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
			},
		},
	},

	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown({
				-- even more opts
			}),

			-- pseudo code / specification for writing custom displays, like the one
			-- for "codeactions"
			-- specific_opts = {
			--   [kind] = {
			--     make_indexed = function(items) -> indexed_items, width,
			--     make_displayer = function(widths) -> displayer
			--     make_display = function(displayer) -> function(e)
			--     make_ordinal = function(e) -> string
			--   },
			--   -- for example to disable the custom builtin "codeactions" display
			--      do the following
			--   codeactions = false,
			-- }
		},
	}
})
-- To get ui-select loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("ui-select")
require("telescope").load_extension("fzf")
