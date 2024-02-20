vim.g.coq_settings = {
	auto_start = "shut-up",
	xdg = true,

	keymap = {
		jump_to_mark = "<tab>",
	},

	clients = {
		tabnine = {
			enabled = false,
		},
	},
	display = {
		preview = {
			border = "shadow",
		},
	},
	limits = {
		completion_auto_timeout = 0.5,
	},
	match = {
		max_results = 100,
	},
}

-- require("coq_3p")({
-- 	{ src = "codeium", short_name = "COD" },
-- })

local presentCodeium, codeium = pcall(require, "codeium")

if not presentCodeium then
	return
end

local codeium_lsp_dir = os.getenv("CODEIUM_LSP_DIR")

codeium.setup({
	tools = {
		language_server = codeium_lsp_dir .. "/bin/codeium-lsp",
	},
})

-- local coq = require("coq")
-- local capabilities = coq.lsp_ensure_capabilities()

require("lspconfig").lua_ls.setup({})
require("lspconfig").kotlin_language_server.setup({})
require("lspconfig").rust_analyzer.setup({})
require("lspconfig").bashls.setup({})
require("lspconfig").rnix.setup({})
require("lspconfig").dockerls.setup({})
require("lspconfig").docker_compose_language_service.setup({})

local root_pattern = require("lspconfig").util.root_pattern

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local function jdt_on_attach(client, bufnr)
	local jdtls = require("jdtls")

	function _extract_variable()
		vim.keymap.set("n", "<c-a-v>", "<cmd>lua require('jdtls').extract_variable()<cr>", {})
		-- jdtls.extract_variable()
	end

	function _extract_method()
		vim.keymap.set("n", "<c-a-m>", "<cmd>lua require('jdtls').extract_method()<cr>", {})
		-- jdtls.extract_method()
	end

	function _debug_nearest_method()
		-- vim.keymap.set("n", "<leader>dn", "<cmd>lua require'jdtls'.test_nearest_method()<CR>", {})
		jdtls.test_nearest_method()
	end

	function _debug_test_class()
		-- vim.keymap.set("n", "<leader>df", "<cmd>lua require'jdtls'.test_class()<CR>", {})
		jdtls.test_class()
	end

	_extract_method()
	_extract_variable()
	jdtls.setup_dap({ hotcodereplace = "auto" })
	require("jdtls.setup").add_commands()
	require("jdtls.dap").setup_dap_main_class_configs()
end

local home = os.getenv("HOME")

function start_jdtls()
	local settings = {
		["java.settings.url"] = home .. "/.config/nvim/formatters/settings.pref",
		["java.format.settings.profile"] = "Helix",
		["java.format.settings.url"] = home .. "/.config/nvim/formatters/eclipse-java-google-style.xml",

		java = {
			signatureHelp = { enabled = true },
			referenceCodeLens = { enabled = true },
			implementationsCodeLens = { enabled = true },
			autobuild = { enabled = true },
			trace = { server = "verbose" },
			contentProvider = { preferred = "fernflower" },
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},
			codeGeneration = {
				toString = {
					template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
				},
			},
		},
	}
	local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
	local root_dir = root_pattern(".git", "gradlew", "mvnw")(bufname)
	local workspace_dir = "/tmp/jdtls_workspaces/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

	local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
	extendedClientCapabilities["progressReportProvider"] = false

	extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

	local java_debug_jar = os.getenv("JAVA_DEBUG_DIR")
	local java_test_jar = os.getenv("JAVA_TEST_DIR")
	local bundles = {
		vim.fn.glob(java_debug_jar, 1),
	}

	vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_jar), "\n"))

	require("jdtls").start_or_attach({
		cmd = { "jdt-ls", "-data", workspace_dir, "-Xmx8g" },
		on_attach = jdt_on_attach,
		root_dir = root_dir,
		capabilities = capabilities,
		settings = settings,
		init_options = {
			bundles = bundles,
			extendedCapabilities = extendedClientCapabilities,
			languageFeatures = {
				codeLens = false,
			},
		},
	})
end

vim.api.nvim_exec(
	[[
		augroup LspCustom
		  autocmd!
		  autocmd FileType java lua start_jdtls()
		augroup END
	]],
	true
)
