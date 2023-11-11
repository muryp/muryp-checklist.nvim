local cekBottomChekbox = function(args)
  return require('muryp-checklist.checkBottomListCheckBox').cekBottomChekbox(args)
end
local checked = function(current_line)
  return require 'muryp-checklist.checked'(current_line)
end
local MAPS = require 'muryp-checklist.maps'

local M = {}

M.RG = {
  checklist = '^[ \t]*- %[[ x]%].*$',
  checked = '^[ \t]*- %[x%].*$',
  unchecked = '^[ \t]*- %[[ ]%].*$',
  list = '^[ \t]*- .*$',
  indent = '^([ \t]*)',
  box = '%[([%s|x])%]',
}

M.toggleCheck = function()
  local current_line = vim.api.nvim_get_current_line() ---@type string
  local line_number = vim.api.nvim_win_get_cursor(0)[1] ---@type number
  local NEW_CONTENT
  if not current_line:match(M.RG.checklist) then
    if current_line:match(M.RG.list) then
      NEW_CONTENT = current_line:gsub('-', '- [ ]', 1)
    else
      NEW_CONTENT = '- ' .. current_line
    end
    vim.api.nvim_buf_set_lines(0, line_number - 1, line_number, true, { NEW_CONTENT })
    return
  end
  local isChecked = string.match(current_line, M.RG.unchecked)
  NEW_CONTENT = checked(current_line)
  vim.api.nvim_buf_set_lines(0, line_number - 1, line_number, true, { NEW_CONTENT })
  cekBottomChekbox { isTobeCheck = isChecked, CURRENT_LINE_NUM = line_number }
end
M.map = ''
---@param opts {fileExt?:string[],map?:string}
M.setup = function(opts)
  local fileExt = { '*.md', '*.txt', 'COMMIT_EDITMSG' }
  if opts.fileExt then
    fileExt = opts.fileExt
  end
  if opts.map then
    M.map = opts.map
  end
  local currentFileType = string.match(vim.fn.expand '%', '.*%.(.*)')
  if currentFileType then
    ---@diagnostic disable-next-line: param-type-mismatch
    for _, value in pairs(fileExt) do
      if value == '*.' .. currentFileType or value:match(currentFileType) then
        MAPS(M.map)
      end
    end
  end

  vim.api.nvim_create_augroup('muryp-checklist', { clear = true })
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = fileExt,
    callback = function()
      MAPS(M.map)
    end,
    group = 'muryp-checklist',
  })
end
M.visualEnter = function()
  local line_start = vim.fn.line "'<"
  local line_end = vim.fn.line "'>"
  local CONTENT = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  if CONTENT[line_start]:match(M.RG.unchecked) then
    for i = line_start, line_end do
      if CONTENT[i]:match(M.RG.unchecked) then
        local NEW_CONTENT = string.gsub(CONTENT[i], M.RG.box, '[x]')
        if i == line_end then
          vim.api.nvim_buf_set_lines(0, i - 1, i, true, { NEW_CONTENT })
          cekBottomChekbox { isTobeCheck = true, CURRENT_LINE_NUM = i }
        end
        vim.api.nvim_buf_set_lines(0, i - 1, i, true, { NEW_CONTENT })
      end
    end
    return
  end
  if CONTENT[line_start]:match(M.RG.checked) then
    for i = line_start, line_end do
      if CONTENT[i]:match(M.RG.checked) then
        local NEW_CONTENT = string.gsub(CONTENT[i], M.RG.box, '[ ]')
        if i == line_end then
          vim.api.nvim_buf_set_lines(0, i - 1, i, true, { NEW_CONTENT })
          cekBottomChekbox { isTobeCheck = false, CURRENT_LINE_NUM = i }
        end
        vim.api.nvim_buf_set_lines(0, i - 1, i, true, { NEW_CONTENT })
      end
    end
    return
  end
  if CONTENT[line_start]:match(M.RG.list) then
    for i = line_start, line_end do
      if CONTENT[i]:match(M.RG.list) then
        local NEW_CONTENT = string.gsub(CONTENT[i], '-', '- [ ]', 1)
        vim.api.nvim_buf_set_lines(0, i - 1, i, true, { NEW_CONTENT })
      end
    end
    return
  end
  for i = line_start, line_end do
    if not (CONTENT[i]:match(M.RG.checklist) and CONTENT[i]:match(M.RG.list)) then
      local NEW_CONTENT = string.gsub(CONTENT[i], M.RG.indent .. '(.*)', '%1- %2')
      vim.api.nvim_buf_set_lines(0, i - 1, i, true, { NEW_CONTENT })
    end
  end
end
return M
