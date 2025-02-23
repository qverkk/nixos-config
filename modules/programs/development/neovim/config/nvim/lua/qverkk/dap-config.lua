_G.bind = vim.api.nvim_set_keymap

-- bind({'n', 'v'}, '<Leader>dh', function()
--   require('dap.ui.widgets').hover()
-- end, {})
-- bind({'n', 'v'}, '<Leader>dp', function()
--   require('dap.ui.widgets').preview()
-- end, {})
-- bind('n', '<Leader>df', function()
--   local widgets = require('dap.ui.widgets')
--   widgets.centered_float(widgets.frames)
-- end, {})
-- bind('n', '<Leader>ds', function()
--   local widgets = require('dap.ui.widgets')
--   widgets.centered_float(widgets.scopes)
-- end, {})

local setup_dap, dap = pcall(require, "dap")
if not setup_dap then
	return
end

local setup_dapui, dapui = pcall(require, "dapui")
if not setup_dapui then
	return
end

require("nvim-dap-virtual-text").setup()
dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end
