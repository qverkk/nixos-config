_G.bind = vim.api.nvim_set_keymap

bind('n', '<F5>', "<cmd> lua require('dap').continue()<CR>", {})
bind('n', '<F1>', "<cmd> lua require('dap').step_over()<CR>", {})
bind('n', '<F2>', "<cmd> lua require('dap').step_into()<CR>", {})
bind('n', '<F3>', "<cmd> lua require('dap').step_out()<CR>", {})
bind('n', '<leader>b', "<cmd> lua require('dap').toggle_breakpoint()<CR>", {})
bind('n', '<leader>B', "<cmd> lua require('dap').set_breakpoint()<CR>", {})
bind('n', '<leader>lp', "<cmd> lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))", {})
bind('n', '<leader>dr', "<cmd> lua require('dap').repl.open()<CR>", {})
bind('n', '<leader>dl', "<cmd> lua require('dap').run_last()<CR>", {})

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

require('nvim-dap-virtual-text').setup()
require('dapui').setup()

local dap, dapui = require('dap'), require('dapui')
dap.listeners.after.event_initialized['dapui_config'] = function ()
	dapui.open()
end
dap.listeners.before.event_terminated['dapui_config'] = function ()
	dapui.close()
end
dap.listeners.before.event_exited['dapui_config'] = function ()
	dapui.close()
end
