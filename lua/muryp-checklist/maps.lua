local addList = require('muryp-checklist.addList')
local function addListMap()
  local CURRENT_TEXT = vim.api.nvim_get_current_line() ---@type string
  if string.match(CURRENT_TEXT, '[\t ]?[-%*]?[%d]*%.?') ~= '' then
    addList()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", true)
  end
end

return function()
  print('exe')
  vim.keymap.set("i", "<CR>", addListMap, { buffer = true })
end