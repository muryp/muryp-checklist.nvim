local cekBottomChekbox = require('nvim-muryp-md.list.checkBottomListCheckBox').cekBottomChekbox
local checked = require('nvim-muryp-md.list.checked')

local M = {}
M.toggleCheck = function()
  local current_line = vim.api.nvim_get_current_line()
  local line_number = vim.api.nvim_win_get_cursor(0)[1]
  local isChecked = string.match(current_line, '^%s*%- %[[ ]%].*$')
  local NEW_CONTENT = checked(current_line)
  vim.api.nvim_buf_set_lines(0, line_number - 1, line_number, true, { NEW_CONTENT })
  cekBottomChekbox({ isTobeCheck = isChecked, CURRENT_LINE_NUM = line_number })
end

-- M.next_bullet = function()
--   local line = vim.api.nvim_get_current_line()
--   local ceckbox = ''
--   if is_list_item(line) then
--     local bullet = string.match(line, "^%s*([%-%*%+]?%s*[0-9]*%.?)%s+.*$")
--     if isCeklist(line) then
--       ceckbox = ' [ ]'
--     end
--     if isListEmpty(line) then
--       if cekLevel() == 0 then
--         vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>A<C-u>", true, false, true), "n", true)
--         return
--       end
--       vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc><<a", true, false, true), "n", true)
--       return
--     end
--     --- cek is have colon
--     if string.match(line, '^.*:') then
--       local backTofirstBullet = bullet:gsub("%d*", function(num)
--         return tonumber(num) and tostring(1) or ""
--       end)
--       vim.api.nvim_feedkeys('\n' .. backTofirstBullet .. ceckbox .. " ", "n", true)
--       vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>>>A", true, false, true), "n", true)
--       return
--     end
--     local next_bullet = bullet:gsub("%d*", function(num)
--       return tonumber(num) and tostring(tonumber(num) + 1) or ""
--     end)
--     --- create emty list/point
--     return vim.api.nvim_feedkeys('\n' .. next_bullet .. ceckbox .. " ", "n", true)
--   end
--   return vim.api.nvim_feedkeys("\n", "n", true)
-- end


return M
