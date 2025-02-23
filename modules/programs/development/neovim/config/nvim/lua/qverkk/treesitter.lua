local setup, plugin = pcall(require, "nvim-treesitter.configs")
if not setup then
	return
end

require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true,
	},
})

