local cekBottomChekbox = require('muryp-checklist.checkBottomListCheckBox').cekBottomChekbox
local checked          = require('muryp-checklist.checked')
local MAPS             = require('muryp-checklist.maps')

local M                = {}
M.toggleCheck          = function()
  local current_line = vim.api.nvim_get_current_line() ---@type string
  local line_number = vim.api.nvim_win_get_cursor(0)[1] ---@type number
  local isChecked = string.match(current_line, '^%s*%- %[[ ]%].*$')
  local NEW_CONTENT = checked(current_line)
  vim.api.nvim_buf_set_lines(0, line_number - 1, line_number, true, { NEW_CONTENT })
  cekBottomChekbox({ isTobeCheck = isChecked, CURRENT_LINE_NUM = line_number })
end

M.setup                = function(opts)
  local fileExt = { '*.md', '*.txt' }
  if opts then
    fileExt = opts
  end
  local currentFileType = string.match(vim.fn.expand('%'), '.*%.(.*)')
  print(vim.inspect(currentFileType))
  for _, value in pairs(fileExt) do
    if value == '*.' .. currentFileType then
      MAPS()
    end
  end

  vim.api.nvim_create_augroup('muryp-checklist', { clear = true })
  vim.api.nvim_create_autocmd(
    { "BufRead", "BufNewFile" }, {
      pattern = fileExt,
      callback = function()
        MAPS()
      end,
      group = 'muryp-checklist',
    })
end
return M