local neotest = require("neotest")

neotest.setup({
	-- diagnostic = { enabled = false },
	-- quickfix = { open = false },
	adapters = {
		-- require("neotest-java")({
		-- 	ignore_wrapper = false, -- whether to ignore maven/gradle wrapper
		-- }),
		require("neotest-jest"),
		require("neotest-vitest")({
			-- Filter directories when searching for test files. Useful in large projects (see Filter directories notes).
			filter_dir = function(name, rel_path, root)
				return name ~= "node_modules" and name ~= ".direnv"
			end,
		}),
		-- require("neotest-gradle"),
		require("neotest-vim-test")({
			allow_file_types = { "java", "kotlin", "groovy" },
		}),
	},
})

require("neodev").setup({
	library = { plugins = { "neotest" }, types = true },
})
