_G.bind = vim.api.nvim_set_keymap

local opt = { noremap = false, silent = true }

-- let test#strategy = "toggleterm"
vim.g["test#strategy"] = "toggleterm"

-- TODO Change these
bind("n", "<space>tt", "<cmd>:TestNearest<cr>", opt)
bind("n", "<space>tT", "<cmd>:TestFile<cr>", opt)
bind("n", "<space>ta", "<cmd>:TestSuite<cr>", opt)
bind("n", "<space>tl", "<cmd>:TestLast<cr>", opt)
bind("n", "<space>tg", "<cmd>:TestVisit<cr>", opt)
