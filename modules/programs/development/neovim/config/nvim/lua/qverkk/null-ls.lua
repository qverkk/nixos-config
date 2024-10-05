local null_ls = require("null-ls")

null_ls.setup({
	border = "rounded",
	sources = {
		-- git
		null_ls.builtins.code_actions.gitsigns,
		-- nix
		null_ls.builtins.code_actions.statix,

		-- using jdtls
		-- java
		-- null_ls.builtins.diagnostics.checkstyle.with({
		-- 	extra_args = { "-c", "/google_checks.xml" }, -- or "/sun_checks.xml" or path to self written rules
		-- }),
		-- nix
		null_ls.builtins.diagnostics.statix,
		null_ls.builtins.diagnostics.deadnix,
		-- dockerfile
		null_ls.builtins.diagnostics.hadolint,
		-- kotlin
		null_ls.builtins.diagnostics.ktlint.with({
			filetypes = { "kt", "kotlin" },
			extra_args = { "**/*.kt" },
		}),
		-- lua
		null_ls.builtins.diagnostics.selene,
		-- Waiting to be added in nixpkgs
		-- gradle, java, jenkins
		-- null_ls.builtins.diagnostics.npm_groovy_lint.with({
		-- 	filetypes = { "groovy", "Jenkinsfile" },
		-- }),
		--
		-- shell
		null_ls.builtins.diagnostics.shellcheck,
		-- html, xml
		null_ls.builtins.diagnostics.tidy,
		-- find todo comments
		null_ls.builtins.diagnostics.todo_comments,

		-- nix
		null_ls.builtins.formatting.nixfmt,
		-- bash
		null_ls.builtins.formatting.beautysh,
		-- java
		-- using jdtls
		-- null_ls.builtins.formatting.google_java_format,
		--
		-- json
		null_ls.builtins.formatting.jq,
		-- kotlin
		null_ls.builtins.formatting.ktlint.with({
			filetypes = { "kt", "kotlin" },
			extra_args = { "**/*.kt" },
		}),
		-- lua
		null_ls.builtins.formatting.stylua,
		-- Waiting to be added in nixpkgs
		-- groovy, jenkins
		-- null_ls.builtins.formatting.npm_groovy_lint.with({
		-- 	filetypes = { "groovy", "Jenkinsfile" },
		-- }),
		--
		-- "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "css", "scss", "less", "html", "json", "jsonc", "yaml", "markdown", "markdown.mdx", "graphql", "handlebars"
		null_ls.builtins.formatting.prettier.with({
			filetypes = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"vue",
				"css",
				"scss",
				"less",
				-- "html",
				-- "json",
				-- "jsonc",
				"yaml",
				"markdown",
				"markdown.mdx",
				"graphql",
				"handlebars",
			},
		}),
		-- rust
		null_ls.builtins.formatting.rustfmt,
		-- toml
		null_ls.builtins.formatting.taplo,
		-- html
		null_ls.builtins.formatting.tidy,
	},
})
