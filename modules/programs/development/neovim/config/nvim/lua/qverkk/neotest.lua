local neotest = require("neotest")

neotest.setup({
	-- diagnostic = { enabled = false },
	-- quickfix = { open = false },
	adapters = {
		require("neotest-java")({
			ignore_wrapper = false, -- whether to ignore maven/gradle wrapper
		}),
		-- require("neotest-gradle"),
	},
})

require("neodev").setup({
	library = { plugins = { "neotest" }, types = true },
})
