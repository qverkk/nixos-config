local cmp = require('cmp')
local compare = require('cmp.config.compare')

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

vim.cmd("set pumheight=8")

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
		end,
	},

	sorting = {
      priority_weight = 2,
      comparators = {
        -- compare.offset,
        -- compare.exact,
        -- compare.scopes,
        -- compare.score,
        compare.recently_used,
        compare.locality,
        compare.sort_text,
        compare.kind,
        compare.length,
        compare.order,
      },
    },

	mapping = {
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				print("next item")
				cmp.select_next_item()
			elseif vim.fn["vsnip#available"] == 1 then
				feedkey("<Plug>(vsnip-expand-or-jump)", "")
			else
				fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_prev_item()
			elseif vim.fn["vsnip#jumpable"](-1) == 1 then
				feedkey("<Plug>(vsnip-jump-prev)", "")
			end
		end, { "i", "s" }),

		['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
		['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
		['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
		['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
		['<C-e>'] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	},
	sources = cmp.config.sources({
		{ name = 'nvim_lsp', priority = 10, max_item_count = 15 },
		{ name = 'nvim_lsp_signature_help', max_item_count = 15 },
		{ name = 'path', priority = 1},
		{ name = 'vsnip', priority = 0 },
		{ name = 'buffer', priority = 0, max_item_count = 5 },
	})

	})

	-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
	cmp.setup.cmdline('/', {
		sources = {
			{ name = 'buffer' }
		}
	})

vim.o.completeopt = "menuone,noselect"
