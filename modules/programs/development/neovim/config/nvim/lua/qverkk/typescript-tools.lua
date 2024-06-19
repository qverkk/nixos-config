require("typescript-tools").setup({
	settings = {
		tsserver_file_preferences = {
			importModuleSpecifierPreference = "non-relative",
		},
	},
	on_attach = function ()
		typescript_mappings()
	end
})
