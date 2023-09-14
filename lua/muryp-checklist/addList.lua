local cekIndent = require('muryp-checklist.cekIndent')
return function()
  local LINE_NUMBER = vim.api.nvim_win_get_cursor(0)[1]
  local CURRENT_TEXT = vim.api.nvim_get_current_line() ---@type string
  local INDENT_COUNT = cekIndent(CURRENT_TEXT)
  if not INDENT_COUNT then
    return
  end
  local bufnr = vim.api.nvim_get_current_buf()
  local NEW_INDENT = ''
  local isAddIndent = string.match(CURRENT_TEXT, '^.*:$')
  local isDelIndent = false
  local listMatch = {
    { '-',         '-' },
    { '([%d]*)%.', '' },
    { '%*',        '*' },
  }
  for _, val in pairs(listMatch) do
    local regex = '^[ \t]*' .. val[1] .. ' '
    local checkboxRegex = '- %[[ x]%] '
    local isMatchList = string.match(CURRENT_TEXT, regex)
    local isMatchDel = string.match(CURRENT_TEXT, regex .. '$') or string.match(CURRENT_TEXT, checkboxRegex .. '$')
    if isMatchDel then
      isDelIndent = true
    end
    if isMatchList then
      if val[1] == '([%d]*)%.' then
        if isAddIndent then
          val[2] = 1 .. '.'
        else
          val[2] = isMatchList + 1 .. '.'
        end
      end
      local checkbox = ''
      if string.match(CURRENT_TEXT, checkboxRegex) then
        checkbox = '[ ] '
      end
      NEW_INDENT = val[2] .. ' ' .. checkbox
    end
  end
  if isAddIndent then
    INDENT_COUNT.indent_size = INDENT_COUNT.indent_size + 1
  end
  if isDelIndent then
    if INDENT_COUNT.indent_size ~= 0 then
      INDENT_COUNT.indent_size = INDENT_COUNT.indent_size - 1
    else
      vim.api.nvim_buf_set_lines(bufnr, LINE_NUMBER - 1, LINE_NUMBER, false, { '' })
      return
    end
  end
  if INDENT_COUNT.isTab then
    NEW_INDENT = string.rep('\t', INDENT_COUNT.softtabstop * INDENT_COUNT.indent_size) .. NEW_INDENT
  else
    NEW_INDENT = string.rep(' ', INDENT_COUNT.shiftwidth * INDENT_COUNT.indent_size) .. NEW_INDENT
  end
  if isDelIndent then
    vim.api.nvim_buf_set_lines(bufnr, LINE_NUMBER - 1, LINE_NUMBER, false, { NEW_INDENT })
    vim.api.nvim_win_set_cursor(0, { LINE_NUMBER, #NEW_INDENT })
    return
  end
  vim.api.nvim_buf_set_lines(bufnr, LINE_NUMBER, LINE_NUMBER, false, { NEW_INDENT })
  vim.api.nvim_win_set_cursor(0, { LINE_NUMBER + 1, #NEW_INDENT })
  return
end