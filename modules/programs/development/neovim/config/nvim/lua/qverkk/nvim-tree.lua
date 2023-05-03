vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
	view = {
-- 		width = table,
		mappings = {
			list = {
				{ key = { "l", "<CR>", "o" }, action = "edit", mode = "n" },
				{ key = "h", action = "close_node" },
				{ key = "v", action = "vsplit" },
				{ key = "C", action = "cd" },
				{ key = "u", action = "dir_up" }
			},
		},
	},
	filters = {
		dotfiles = true,
	},
	update_focused_file = {
		enable = true,
-- 		debounce_delay = 15,
		update_root = true,
		ignore_list = {},
	},
})
