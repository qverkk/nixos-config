local ts = vim.treesitter
local ts_utils = require("nvim-treesitter.ts_utils")

local M = {}

function M.goto_translation()
  local ft = vim.bo.filetype

  if not string.find(ft, "[java|type]script") then
    return false
  end

  local node = ts_utils.get_node_at_cursor(0)

  while
    node
    and (
      node:type() ~= "call_expression"
      or (
        node:type() == "call_expression"
        and vim.treesitter.get_node_text(node:field("function")[1], 0) ~= "i18n._"
		and vim.treesitter.get_node_text(node:field("function")[1], 0) ~= "i18n"
      )
    )
  do
    node = node:parent()
  end

  if not node then
    print('There is no "i18n" function under cursor!')
    return false
  end

  local args = node:field("arguments")[1]
  local name = vim.treesitter.get_node_text(args:child(1):child(1), 0)

  if not name then
    vim.notify("Treesitter parse failed")
    return false
  end

  local po_winid = vim.fn.bufwinid(vim.fn.bufnr("src/translations/pl-PL.po"))

  if po_winid == -1 then
    vim.cmd(":vs ./src/translations/pl-PL.po")
  else
    vim.api.nvim_set_current_win(po_winid)
  end

  local translation_found = vim.fn.search('"' .. name .. '"')

  vim.cmd("nohl")

  if translation_found == 0 then
    local handle_select_choice = function(picked_option)
      if picked_option == "Yes" then
        vim.api.nvim_command('! npx @allegro/i18n-tools add "' .. name .. '" "' .. name .. '" -t')
        -- vim.api.nvim_buf_set_lines(
        --   0,
        --   -1,
        --   -1,
        --   false,
        --   { " ", 'msgid "' .. name .. '"', 'msgstr "' .. name .. '"' }
        -- )
      end
    end

    vim.ui.select(
      { "Yes", "No" },
      { prompt = "Create missing translation?", telescope = { initial_mode = "normal" } },
      handle_select_choice
    )
  end

  return true
end

return M
