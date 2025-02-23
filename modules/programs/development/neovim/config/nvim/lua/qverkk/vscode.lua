_G.bind = vim.api.nvim_set_keymap

local opt = { noremap = false, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = ";"

-- Better navigation
bind("n", "<C-h>", ":call VSCodeNotify('workbench.action.navigateLeft')<CR>", opt)
bind("x", "<C-h>", ":call VSCodeNotify('workbench.action.navigateLeft')<CR>", opt)
bind("n", "<C-l>", ":call VSCodeNotify('workbench.action.navigateRight')<CR>", opt)
bind("x", "<C-l>", ":call VSCodeNotify('workbench.action.navigateRight')<CR>", opt)
bind("n", "<C-j>", ":call VSCodeNotify('workbench.action.navigateDown')<CR>", opt)
bind("x", "<C-j>", ":call VSCodeNotify('workbench.action.navigateDown')<CR>", opt)
bind("n", "<C-k>", ":call VSCodeNotify('workbench.action.navigateUp')<CR>", opt)
bind("x", "<C-k>", ":call VSCodeNotify('workbench.action.navigateUp')<CR>", opt)

-- jump 10 lines when holding shift
bind("n", "<s-j>", "10j", opt)
bind("n", "<s-k>", "10k", opt)
bind("v", "<s-j>", "10j", opt)
bind("v", "<s-k>", "10k", opt)

-- escape by jk
bind("i", "jk", "<ESC>", { noremap = false, silent = true })
bind("t", "jk", "<C-\\><C-n>", { noremap = false, silent = true })
