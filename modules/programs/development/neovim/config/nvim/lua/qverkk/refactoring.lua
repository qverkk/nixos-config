local setup, plugin = pcall(require, "refactoring")
if not setup then
	return
end

plugin.setup({})

-- load refactoring Telescope extension
require("telescope").load_extension("refactoring")
