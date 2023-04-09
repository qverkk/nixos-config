_G.bind = vim.api.nvim_set_keymap

local opt = { noremap = false, silent = true }

vim.g.mapleader = " "

-- Better navigation
bind("n", "<C-h>", "<C-w>h", opt)
bind("n", "<C-l>", "<C-w>l", opt)
bind("n", "<C-j>", "<C-w>j", opt)
bind("n", "<C-k>", "<C-w>k", opt)


-- jump 10 lines when holding shift
bind("n", "<s-j>", "10j<cr>", opt)
bind("n", "<s-k>", "10k<cr>", opt)
bind("v", "<s-j>", "10j<cr>", opt)
bind("v", "<s-k>", "10k<cr>", opt)

-- show the error message when hovering
bind(
	"n",
	"<a-q>",
	"<cmd>lua vim.diagnostic.open_float({focusable = false, show_header = false})<cr>",
	opt
)

-- format
bind("n", "<c-a-l>", "<cmd>lua vim.lsp.buf.format()<cr>", opt)

-- code actions
bind("n", "<a-cr>", "<cmd>lua vim.lsp.buf.code_action()<cr>", {})
bind("v", "<a-cr>", "<cmd>lua vim.lsp.buf.code_action()<cr>", {})
-- bind("n", "<a-e>", "<cmd>lua vim.lsp.buf.rename()<cr>", {}) -- shift f6?
bind("i", "<a-q>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", {})

-- goto jumps
bind("n", "<a-i>", "<cmd>:Telescope lsp_implementations<cr>", opt)
bind("n", "<a-d>", "<cmd>:Telescope lsp_definitions<cr>", opt)
bind("n", "<a-r>", "<cmd>:Telescope lsp_references<cr>", opt)
bind("n", "<a-c>", "<cmd>:Telescope lsp_dynamic_workspace_symbols<cr>", opt)

-- diagnostics
bind("n", "<a-c-q>", "<cmd>:Telescope diagnostics<cr>", {})
bind("n", "<a-[>", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opt)
bind("n", "<a-]>", "<cmd>lua vim.diagnostic.goto_next()<cr>", opt)
