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

require("nvim-dap-virtual-text").setup()
require("dapui").setup()

local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end
