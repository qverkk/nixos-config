_G.bind = vim.api.nvim_set_keymap

local opt = { noremap = false, silent = true }

require("symbols-outline").setup()

bind("n", "<space>fs", "<cmd>:SymbolsOutline<cr>", opt)
