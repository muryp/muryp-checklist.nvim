local addList = require 'muryp-checklist.addList'
local RG = '[\t ]?[-%*]?[%d]*%.?'

local function entrInsert()
  local CURRENT_TEXT = vim.api.nvim_get_current_line() ---@type string
  local CURRENT_COL = vim.fn.col '.' ---@type number
  if CURRENT_COL == 1 then
    return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, false, true), 'n', true)
  end
  if CURRENT_TEXT:match(RG) ~= '' then
    if #CURRENT_TEXT > CURRENT_COL then
      local isCheckbox = string.match(CURRENT_TEXT, '^[\t ]?-[ ]%[[%s|x]%]')
      if isCheckbox then
        return vim.api.nvim_feedkeys('\r- [ ] ', 'n', true)
      end
      return vim.api.nvim_feedkeys('\r- ', 'n', true)
    end
    addList()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, false, true), 'n', true)
  end
end

---@param args string mapping toggle
return function(args)
  vim.keymap.set('i', '<CR>', entrInsert, { buffer = true })
  vim.keymap.set('n', 'o', function()
    local CURRENT_TEXT = vim.api.nvim_get_current_line() ---@type string
    if string.match(CURRENT_TEXT, RG) ~= '' then
      addList()
      return vim.api.nvim_feedkeys('A', 'n', true)
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('o', true, false, true), 'n', true)
  end, { buffer = true })
  if args == '' then
    return
  end
  local opts = { buffer = true, noremap = true, silent = true }
  vim.keymap.set('n', args, ":lua require('muryp-checklist').toggleCheck()<CR>", opts)
  vim.keymap.set('n', '<leader>"', function()
    local current_line = vim.api.nvim_get_current_line() ---@type string
    local line_number = vim.api.nvim_win_get_cursor(0)[1] ---@type number
    local NEW_CONTENT = current_line:gsub('^%s*%- %[[ x]%] ', '', 1)
    vim.api.nvim_buf_set_lines(0, line_number - 1, line_number, true, { NEW_CONTENT })
  end, opts)
  vim.keymap.set('v', args, ":lua require('muryp-checklist').visualEnter()<CR>", opts)
end