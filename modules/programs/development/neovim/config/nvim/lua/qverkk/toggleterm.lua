local setup, plugin = pcall(require, "toggleterm")
if not setup then
	return
end

plugin.setup({
	shell = "zsh",
})

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })

function _lazygit_toggle()
	lazygit:toggle()
end
