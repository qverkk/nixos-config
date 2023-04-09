require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"jdtls",
		"kotlin_language_server",
		"rust_analyzer"
	}
})


require("lspconfig").lua_ls.setup {}
require("lspconfig").kotlin_language_server.setup {}
require("lspconfig").rust_analyzer.setup {}
require("lspconfig").bashls.setup {}

-- java
local java_mappings_on_attach = function(_, _)
	vim.keymap.set("n", "<c-a-v>", "<cmd>lua require('jdtls').extract_variable()<cr>", {})
	vim.keymap.set("n", "<c-a-m>", "<cmd>lua require('jdtls').extract_method()<cr>", {})
end

-- calculate workspace dir
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = os.getenv("HOME") .. "/.cache/jdtls/workspace/" .. project_name
os.execute("mkdir " .. workspace_dir)

-- get the mason install path
local install_path = require("mason-registry").get_package("jdtls"):get_install_path()

-- get the current OS
local home = os.getenv("HOME")
local os
if vim.fn.has("mac") == 1 then
	os = "mac"
elseif vim.fn.has("win32") == 1 then
	os = "win"
else
	os = "linux"
end

require("lspconfig").jdtls.setup {
	on_attach = java_mappings_on_attach,
	cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-javaagent:" .. install_path .. "/lombok.jar",
		"-Xms1g",
		"-Xmx8g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-jar",
		vim.fn.glob(install_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
		"-configuration",
		install_path .. "/config_" .. os,
		"-data",
		workspace_dir,
	}
}
