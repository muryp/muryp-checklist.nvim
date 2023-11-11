local checked = require 'muryp-checklist.checked'
local RG = require('muryp-checklist').RG

---@param PARENT_NUM number
---@param isTobeCheck boolean
---@return number | false
return function(PARENT_NUM, isTobeCheck)
  local CONTENT_PARENT = vim.api.nvim_buf_get_lines(0, PARENT_NUM - 1, PARENT_NUM, true)[1]
  local INDENT_CHAR = string.match(CONTENT_PARENT, RG.indent)

  for ABOVE_LINE_NUM = PARENT_NUM - 1, 1, -1 do
    ---@type string
    local CONTENT_ABOVE = vim.api.nvim_buf_get_lines(0, ABOVE_LINE_NUM - 1, ABOVE_LINE_NUM, true)[1]
    local INDENT_ABOVE_CHAR = string.match(CONTENT_ABOVE, RG.indent) ---@type string
    local isNextSibling = #INDENT_ABOVE_CHAR == #INDENT_CHAR
    local isNextParent = #INDENT_ABOVE_CHAR < #INDENT_CHAR
    local isNextChildern = #INDENT_ABOVE_CHAR > #INDENT_CHAR
    local isNextSiblingChildern = isNextChildern or isNextSibling
    local isChecked = string.match(CONTENT_ABOVE, RG.checklist) ---@type string | nil
    local isUnChecked = string.match(CONTENT_ABOVE, RG.unchecked) ---@type string | nil
    local isCheckbox = isChecked or isUnChecked
    local isNotBlank = CONTENT_ABOVE ~= ''
    --- this cecking for expect tobe check or uncheck but got diferent
    local isNotExpect = isTobeCheck and isUnChecked or not isTobeCheck and isChecked
    if isNotBlank and not isCheckbox or not isTobeCheck and isNextParent and isUnChecked then
      return false
    end
    if isNotBlank then
      if isNextParent and isNotExpect then
        local NEW_CONTENT = checked(CONTENT_ABOVE)
        vim.api.nvim_buf_set_lines(0, ABOVE_LINE_NUM - 1, ABOVE_LINE_NUM, true, { NEW_CONTENT })
        return ABOVE_LINE_NUM
      end
      if isNextSiblingChildern and isNotExpect and isTobeCheck or #INDENT_ABOVE_CHAR < 1 then
        return false
      end
    end
  end
  return false
end
