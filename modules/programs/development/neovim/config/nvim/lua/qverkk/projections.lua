require("projections").setup({
	store_hooks = {
		pre = function()
			local nvim_tree_present, api = pcall(require, "nvim-tree.api")
			if nvim_tree_present then
				api.tree.close()
			end
		end,
	},
	workspaces = {
		{ "~/Documents",     { ".git" } },
		{ "~/Documents/dev", { ".git" } },
		{ "~/Downloads",     { ".git" } },
	},
})

require("telescope").load_extension("projections")

vim.opt.sessionoptions:append("localoptions")

-- Autostore session on VimExit
local Session = require("projections.session")
vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
	callback = function()
		Session.store(vim.loop.cwd())
	end,
})

-- Switch to project if vim was started in a project dir
local switcher = require("projections.switcher")
vim.api.nvim_create_autocmd({ "VimEnter" }, {
	callback = function()
		if vim.fn.argc() == 0 then
			switcher.switch(vim.loop.cwd())
		end
	end,
})
