local rest_nvim = require("rest-nvim")
local autocmd = vim.api.nvim_create_autocmd

rest_nvim.setup({
	result_split_in_place = "top|right",
	-- Open request results in a horizontal split
	result_split_horizontal = false,
	-- Skip SSL verification, useful for unknown certificates
	skip_ssl_verification = false,
	-- Highlight request on run
	highlight = {
		enabled = true,
		timeout = 150,
	},
	result = {
		-- toggle showing URL, HTTP info, headers at top the of result window
		show_url = true,
		show_http_info = true,
		show_headers = true,
	},
	-- Jump to request line on run
	jump_to_request = false,
	custom_dynamic_variables = {},
	env_file = ".env",
})

vim.filetype.add({ extension = { http = "http" } })

autocmd("FileType", {
	pattern = { "http", "text", "*" },
	callback = http_mappings,
	desc = "HTTP Buffer mappings",
})
