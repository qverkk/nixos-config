-- vim.api.nvim_exec(
-- 	[[
-- 		augroup jdtls_lsp
-- 			autocmd!
-- 			autocmd FileType java lua require("lsp.java").setup()
-- 		augroup end
-- 	]],
-- 	true
-- )

-- local api = vim.api
-- local lsp = vim.lsp
-- local uv = vim.loop
-- local path = require('jdtls.path')

-- local M = {}

-- function M.find_root(markers, bufname)
-- 	bufname = bufname or api.nvim_buf_get_name(api.nvim_get_current_buf())
-- 	local dirname = vim.fn.fnamemodify(bufname, ':p:h')

-- 	local getparent = function(p)
-- 		return vim.fn.fnamemodify(p, ':h')
-- 	end

-- 	while getparent(dirname) ~= dirname do
-- 		for _, marker in ipairs(markers) do
-- 			if dirname:sub(-string.len(marker)) == marker then
-- 				return dirname
-- 			end
-- 		end
-- 		dirname = getparent(dirname)
-- 	end
-- end

-- function M.setup()
-- 	local build_src_dir = M.find_root( { "buildSrc" })

-- 	local root_dir = nil

-- 	if build_src_dir == nil then
-- 		root_dir = require("jdtls.setup").find_root({ "gradlew", "mvnw" })
-- 	else
-- 		root_dir = build_src_dir
-- 	end
-- 	
-- 	if root_dir == nil then
-- 		return
-- 	end

-- 	local on_attach = function(client, bufnr)
-- 		require("jdtls.setup").add_commands()
-- 	end

-- 	local extra_capabilities = {
-- 		workspace = {
-- 			configuration = true
-- 		};

-- 		textDocument = {
-- 			completion = {
-- 				completionItem = {
-- 					snippetSupport = true
-- 				}
-- 			};
-- 		}
-- 	}

-- 	local capabilities = vim.tbl_deep_extend('keep', extra_capabilities,vim.lsp.protocol.make_client_capabilities())
-- 	local home = os.getenv('HOME')
-- 	local workspace_folder = home .. "/.workspace" .. string.gsub(root_dir, "/", "." )
-- 	local config = {
-- 		flags = {
-- 			allow_incremental_sync = true,
-- 		};
-- 		capabilities = capabilities,
-- 		on_attach = on_attach,
-- 		settings = {
-- 			['java.settings.url'] = home .. "/.config/eclipse/settings.pref",
-- 			['java.format.settings.profile'] = "GoogleStyle",
-- 			['java.format.settings.url'] = home .. "/.config/eclipse-formatter.xml",

-- 			java = {
-- 				signatureHelp = { enabled = true };

-- 				contentProvider = { preferred = 'fernflower' };

-- 				sources = {
-- 					organizeImports = {
-- 						starThreshold = 9999;
-- 						staticStarThreshold = 9999;
-- 					};
-- 				};

-- 				codeGeneration = {
-- 					toString = {
-- 						template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
-- 					}
-- 				};

-- 				configuration = {
-- 					runtimes = { }
-- 				};
-- 			};
-- 		}
-- 	}
-- 	
-- 	config.root_dir = root_dir
-- 	config.cmd = { "java-lsp", workspace_folder }
-- 	config.on_init = function(client, _)
-- 		client.notify("workspace/didChangeConfiguration", { settings = config.settings })
-- 	end


-- 	local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
-- 	extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

-- 	config.init_options = {
-- 		extendedClientCapabilities = extendedClientCapabilities;
-- 		languageFeatures = {
-- 			codeLens = false
-- 		}
-- 	}

-- 	require('jdtls').start_or_attach(config)
-- end

-- return M


-- local status, jdtls = pcall(require, "jdtls")
-- if not status then
-- 	return
-- end

-- -- Determine OS
-- local home = os.getenv("HOME")
-- if vim.fn.has("mac") == 1 then
-- 	WORKSPACE_PATH = home .. "/workspace/"
-- 	CONFIG = "mac"
-- elseif vim.fn.has("unix") == 1 then
-- 	WORKSPACE_PATH = home .. "/workspace/"
-- 	CONFIG = "linux"
-- else
-- 	print("Unsupported system")
-- end

-- -- Find root of project
-- local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
-- local root_dir = require("jdtls.setup").find_root(root_markers)
-- if root_dir == "" then
-- 	return
-- end

-- local extendedClientCapabilities = jdtls.extendedClientCapabilities
-- extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

-- local extra_capabilities = {
-- 	workspace = {
-- 		configuration = true
-- 	};

-- 	textDocument = {
-- 		completion = {
-- 			completionItem = {
-- 				snippetSupport = true
-- 			}
-- 		};
-- 	}
-- }


-- local capabilities = vim.tbl_deep_extend('keep', extra_capabilities,vim.lsp.protocol.make_client_capabilities())

-- local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

-- local workspace_dir = WORKSPACE_PATH .. project_name

-- local bundles = {}
-- local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")
-- -- vim.list_extend(bundles, vim.split(vim.fn.glob(mason_path .. "packages/java-test/extension/server/*.jar"), "\n"))
-- -- vim.list_extend(
-- -- 	bundles,
-- -- 	vim.split(
-- -- 		vim.fn.glob(mason_path .. "packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"),
-- -- 		"\n"
-- -- 	)
-- -- )

-- -- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
-- local config = {
-- 	-- The command that starts the language server
-- 	-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
-- 	cmd = {

-- 		-- 💀
-- 		"java", -- or '/path/to/java11_or_newer/bin/java'
-- 		-- depends on if `java` is in your $PATH env variable and if it points to the right version.

-- 		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
-- 		"-Dosgi.bundles.defaultStartLevel=4",
-- 		"-Declipse.product=org.eclipse.jdt.ls.core.product",
-- 		"-Dlog.protocol=true",
-- 		"-Dlog.level=ALL",
-- 		"-javaagent:" .. home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
-- 		"-Xms1g",
-- 		"-Xmx8g",
-- 		"--add-modules=ALL-SYSTEM",
-- 		"--add-opens",
-- 		"java.base/java.util=ALL-UNNAMED",
-- 		"--add-opens",
-- 		"java.base/java.lang=ALL-UNNAMED",

-- 		-- 💀
-- 		"-jar",
-- 		vim.fn.glob(home .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
-- 		-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
-- 		-- Must point to the                                                     Change this to
-- 		-- eclipse.jdt.ls installation                                           the actual version

-- 		-- 💀
-- 		"-configuration",
-- 		home .. "/.local/share/nvim/mason/packages/jdtls/config_" .. CONFIG,
-- 		-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
-- 		-- Must point to the                      Change to one of `linux`, `win` or `mac`
-- 		-- eclipse.jdt.ls installation            Depending on your system.

-- 		-- 💀
-- 		-- See `data directory configuration` section in the README
-- 		"-data",
-- 		workspace_dir,
-- 	},

-- 	capabilities = capabilities,

-- 	-- 💀
-- 	-- This is the default if not provided, you can remove it. Or adjust as needed.
-- 	-- One dedicated LSP server & client will be started per unique root_dir
-- 	root_dir = root_dir,

-- 	-- Here you can configure eclipse.jdt.ls specific settings
-- 	-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
-- 	-- or https://github.com/redhat-developer/vscode-java#supported-vs-code-settings
-- 	-- for a list of options
-- 	settings = {
-- 		java = {
-- 			-- jdt = {
-- 			--   ls = {
-- 			--     vmargs = "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m"
-- 			--   }
-- 			-- },
-- 			eclipse = {
-- 				downloadSources = true,
-- 			},
-- 			configuration = {
-- 				updateBuildConfiguration = "interactive",
-- 				runtimes = {
-- 					{
-- 						name = "JavaSE-11",
-- 						path = "~/.sdkman/candidates/java/11.0.18-tem",
-- 					},
-- 					{
-- 						name = "JavaSE-17",
-- 						path = "~/.sdkman/candidates/java/17.0.4.1-tem",
-- 					},
-- 				},
-- 			},
-- 			maven = {
-- 				downloadSources = true,
-- 			},
-- 			implementationsCodeLens = {
-- 				enabled = true,
-- 			},
-- 			referencesCodeLens = {
-- 				enabled = true,
-- 			},
-- 			references = {
-- 				includeDecompiledSources = true,
-- 			},
-- 			inlayHints = {
-- 				parameterNames = {
-- 					enabled = "all", -- literals, all, none
-- 				},
-- 			},
-- 			format = {
-- 				enabled = true,
--       		  	settings = {
-- 					url = vim.fn.stdpath "config" .. "/formatters/intellij-java-google-style.xml",
--       		  	  	profile = "GoogleStyle",
--       		  	},
--       		},
-- 		},
-- 		signatureHelp = { enabled = true },
-- 		completion = {
-- 			favoriteStaticMembers = {
-- 				"org.hamcrest.MatcherAssert.assertThat",
-- 				"org.hamcrest.Matchers.*",
-- 				"org.hamcrest.CoreMatchers.*",
-- 				"org.junit.jupiter.api.Assertions.*",
-- 				"java.util.Objects.requireNonNull",
-- 				"java.util.Objects.requireNonNullElse",
-- 				"org.mockito.Mockito.*",
-- 			},
-- 		},
-- 		contentProvider = { preferred = "fernflower" },
-- 		extendedClientCapabilities = extendedClientCapabilities,
-- 		sources = {
-- 			organizeImports = {
-- 				starThreshold = 9999,
-- 				staticStarThreshold = 9999,
-- 			},
-- 		},
-- 		codeGeneration = {
-- 			toString = {
-- 				template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
-- 			},
-- 			useBlocks = true,
-- 		},
-- 	},

-- 	flags = {
-- 		allow_incremental_sync = true,
-- 	},

-- 	-- Language server `initializationOptions`
-- 	-- You need to extend the `bundles` with paths to jar files
-- 	-- if you want to use additional eclipse.jdt.ls plugins.
-- 	--
-- 	-- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
-- 	--
-- 	-- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
-- 	init_options = {
-- 		-- bundles = {},
-- 		bundles = bundles,
-- 	},
-- }

-- config["on_attach"] = function(client, bufnr)
-- 	local _, _ = pcall(vim.lsp.codelens.refresh)
-- 	-- require("jdtls.dap").setup_dap_main_class_configs()
-- 	-- require("jdtls").setup_dap({ hotcodereplace = "auto" })
-- 	-- require("lvim.lsp").on_attach(client, bufnr)
-- end

-- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
-- 	pattern = { "*.java" },
-- 	callback = function()
-- 		local _, _ = pcall(vim.lsp.codelens.refresh)
-- 	end,
-- })

-- -- This starts a new client & server,
-- -- or attaches to an existing client & server depending on the `root_dir`.
-- jdtls.start_or_attach(config)

-- vim.cmd(
-- 	[[command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)]]
-- )
-- vim.cmd([[command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()]])
-- -- vim.cmd "command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)"
-- -- -- vim.cmd "command! -buffer JdtJol lua require('jdtls').jol()"
-- -- vim.cmd "command! -buffer JdtBytecode lua require('jdtls').javap()"
-- -- -- vim.cmd "command! -buffer JdtJshell lua require('jdtls').jshell()"

-- -- local opts = {
-- -- 	mode = "n", -- NORMAL mode
-- -- 	prefix = "<leader>",
-- -- 	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
-- -- 	silent = true, -- use `silent` when creating keymaps
-- -- 	noremap = true, -- use `noremap` when creating keymaps
-- -- 	nowait = true, -- use `nowait` when creating keymaps
-- -- }

-- -- local vopts = {
-- -- 	mode = "v", -- VISUAL mode
-- -- 	prefix = "<leader>",
-- -- 	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
-- -- 	silent = true, -- use `silent` when creating keymaps
-- -- 	noremap = true, -- use `noremap` when creating keymaps
-- -- 	nowait = true, -- use `nowait` when creating keymaps
-- -- }

-- -- local mappings = {
-- -- 	C = {
-- -- 		name = "Java",
-- -- 		o = { "<Cmd>lua require'jdtls'.organize_imports()<CR>", "Organize Imports" },
-- -- 		v = { "<Cmd>lua require('jdtls').extract_variable()<CR>", "Extract Variable" },
-- -- 		c = { "<Cmd>lua require('jdtls').extract_constant()<CR>", "Extract Constant" },
-- -- 		t = { "<Cmd>lua require'jdtls'.test_nearest_method()<CR>", "Test Method" },
-- -- 		T = { "<Cmd>lua require'jdtls'.test_class()<CR>", "Test Class" },
-- -- 		u = { "<Cmd>JdtUpdateConfig<CR>", "Update Config" },
-- -- 	},
-- -- }

-- -- local vmappings = {
-- -- 	C = {
-- -- 		name = "Java",
-- -- 		v = { "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", "Extract Variable" },
-- -- 		c = { "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", "Extract Constant" },
-- -- 		m = { "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", "Extract Method" },
-- -- 	},
-- -- }

