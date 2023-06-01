vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local function on_attach(bufnr)
	local api = require('nvim-tree.api')

	local function opts(desc)
		return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
	vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
	vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))

	vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
	vim.keymap.set('n', 'v', api.node.open.vertical, opts('Open: Vertical Split'))
	vim.keymap.set('n', 'C', api.tree.change_root_to_node, opts('CD'))
	vim.keymap.set('n', 'u', api.tree.change_root_to_parent, opts('Dir up'))
end

require("nvim-tree").setup({
	on_attach = on_attach,
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
