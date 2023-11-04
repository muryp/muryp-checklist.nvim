local addList = require('muryp-checklist.addList')
local function addListMap()
  local CURRENT_TEXT = vim.api.nvim_get_current_line() ---@type string
  if string.match(CURRENT_TEXT, '[\t ]?[-%*]?[%d]*%.?') ~= '' then
    addList()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", true)
  end
end

---@param args string mapping toggle
return function(args)
  vim.keymap.set("i", "<CR>", addListMap, { buffer = true })
  if args == '' then
    return
  end
  vim.keymap.set("n", args, function()
    local toggleCheckbox = require('muryp-checklist').toggleCheck
    toggleCheckbox()
  end, { buffer = true })
end