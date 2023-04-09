_G.bind = vim.api.nvim_set_keymap

require("gitsigns").setup()

bind("n", "<c-b>", "<cmd>Gitsigns blame_line<cr>", {})

