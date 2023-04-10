require("lspconfig").sumneko_lua.setup {}
require("lspconfig").kotlin_language_server.setup {}
require("lspconfig").rust_analyzer.setup {}
require("lspconfig").bashls.setup {}

local root_pattern = require("lspconfig").util.root_pattern

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local function jdt_on_attach(client, bufnr)
	vim.keymap.set("n", "<c-a-v>", "<cmd>lua require('jdtls').extract_variable()<cr>", {})
	vim.keymap.set("n", "<c-a-m>", "<cmd>lua require('jdtls').extract_method()<cr>", {})
	require("jdtls.setup").add_commands()
end

function start_jdtls()
  local settings = {
    java = {
      signatureHelp = { enabled = true },
      referenceCodeLens = { enabled = true },
      implementationsCodeLens = { enabled = true },
      autobuild = { enabled = true },
      trace = { server = "verbose" },
      contentProvider = { preferred = 'fernflower' };
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

  require("jdtls").start_or_attach({
    cmd = { "jdt-ls", "-data", workspace_dir, "-Xmx8g" },
    on_attach = jdt_on_attach,
    root_dir = root_dir,
    capabilities = capabilities,
    settings = settings,
    init_options = {
      bundles = bundles,
      extendedCapabilities = require("jdtls").extendedClientCapabilities,
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
