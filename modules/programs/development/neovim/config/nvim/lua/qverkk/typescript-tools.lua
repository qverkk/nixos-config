local setup, plugin = pcall(require, "typescript-tools")
if not setup then
	return
end

plugin.setup({
	settings = {
		tsserver_file_preferences = {
			importModuleSpecifierPreference = "non-relative",
		},
	},
	on_attach = function ()
		typescript_mappings()
	end
})
