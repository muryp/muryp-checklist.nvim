local chekTopListCheckbox = require('nvim-muryp-md.list.chekTopListCheckbox')
local checked = require('nvim-muryp-md.list.checked')
local M = {}

---this function chekcing bottom cheklist on childern and sibling, and if have childern will be toggle check
---@param args {CURRENT_LINE_NUM:number,PARENT_LINE:number,isTobeCheck:boolean,LAST_CONTENT:boolean}
function M.cekBottomChekbox(args)
  -- args
  local CURRENT_LINE_NUM   = args.CURRENT_LINE_NUM ---@type number
  local PARENT_LINE        = args.PARENT_LINE or args.CURRENT_LINE_NUM ---@type number
  local isTobeCheck        = args.isTobeCheck ---@type boolean
  local STORE              = {}
  STORE.LAST_CONTENT       = args.LAST_CONTENT or false ---@type boolean
  STORE.isParentTobeToggle = true ---@type boolean

  --is have more childern on bottom to be check
  if not STORE.LAST_CONTENT then
    -- store
    STORE.PARENT_CONTEN     = vim.api.nvim_buf_get_lines(0, PARENT_LINE - 1, PARENT_LINE, true)[1] ---@type string
    STORE.INDENT_CHAR       = string.match(STORE.PARENT_CONTEN, '^([ \t]*)') ---@type string
    STORE.INDENT_SIZE       = #STORE.INDENT_CHAR ---@type number
    STORE.TOTAL_LINES       = vim.api.nvim_buf_line_count(0) ---@type number
    STORE.LAST_NUM          = CURRENT_LINE_NUM ---@type number
    STORE.childernCheck     = true ---@type boolean

    --- if tobe check but current line is unceck stop it
    local BOTTOM_CONTEN     = vim.api.nvim_buf_get_lines(0, CURRENT_LINE_NUM - 1, CURRENT_LINE_NUM, true)
        [1] ---@type string
    local isUnCheckedBottom = string.match(BOTTOM_CONTEN, '^%s*%- %[[ ]%].*$')
    if isTobeCheck and isUnCheckedBottom then
      return
    end

    for NEXT_LINE_NUM = CURRENT_LINE_NUM + 1, STORE.TOTAL_LINES do
      local NEXT_CONTENT_LINE = vim.api.nvim_buf_get_lines(0, NEXT_LINE_NUM - 1, NEXT_LINE_NUM, true)[1]
      local isChecked         = string.match(NEXT_CONTENT_LINE, '^%s*%- %[[xX]%].*$')
      local isUnChecked       = string.match(NEXT_CONTENT_LINE, '^%s*%- %[[ ]%].*$')
      local isCheckbox        = isChecked or isUnChecked
      local INDENT_NEXT_CHAR  = string.match(NEXT_CONTENT_LINE, '^([ \t]*)')
      local INDENT_NEXT_SIZE  = #INDENT_NEXT_CHAR
      ---childern by indent
      local isChildern        = STORE.INDENT_SIZE < INDENT_NEXT_SIZE
      local isSibling         = STORE.INDENT_SIZE == INDENT_NEXT_SIZE
      ---parent by indent
      local isParent          = STORE.INDENT_SIZE > INDENT_NEXT_SIZE
      local isContentBlank    = NEXT_CONTENT_LINE == ''
      ---if content must expect checked or unchecked but expectation false
      local isAction          = isTobeCheck and isUnChecked or not isTobeCheck and isChecked
      local isTobeUncheck     = not STORE.childernCheck and not isTobeCheck

      STORE.LAST_NUM          = NEXT_LINE_NUM
      if isTobeUncheck or INDENT_NEXT_SIZE < 1 then
        STORE.LAST_CONTENT = true
        break
      end
      if isParent then
        break
      end
      if isAction and not STORE.childernCheck then
        STORE.isParentTobeToggle = false
        break
      end
      --- checked or unchecked childern if have
      if STORE.childernCheck and isChildern and isCheckbox or isContentBlank then
        if isAction then
          local NEW_CONTENT = checked(NEXT_CONTENT_LINE)
          vim.api.nvim_buf_set_lines(0, NEXT_LINE_NUM - 1, NEXT_LINE_NUM, true, { NEW_CONTENT })
        end
      else
        if isTobeCheck and (isChildern or isSibling) and isUnChecked then
          return
        end
        STORE.childernCheck = false
        PARENT_ROOT_CONTEN  = vim.api.nvim_buf_get_lines(0, PARENT_LINE - 2, PARENT_LINE - 1, true)[1] ---@type string
        INDENT_ROOT_CHAR    = string.match(STORE.PARENT_CONTEN, '^([ \t]*)') ---@type string
        local isRoot        = #INDENT_ROOT_CHAR < 1
        if isAction and isTobeUncheck then
          return
        end
        ---check bottom childern or sibling not expect
        if isRoot then
          STORE.LAST_CONTENT = true
          break
        end
      end
    end
  end

  if not STORE.isParentTobeToggle then
    return
  end
  local isParentTrue = chekTopListCheckbox(PARENT_LINE, isTobeCheck)
  --- if parent is ok
  if isParentTrue then
    local ABOVE_PARENT_NUM    = isParentTrue - 1
    local PARENT_NEXT_CONTENT = vim.api.nvim_buf_get_lines(0, ABOVE_PARENT_NUM - 1, ABOVE_PARENT_NUM, true)[1]
    local PARENT_NEXT_INDENT  = string.match(PARENT_NEXT_CONTENT, '^([ \t]*)')
    local PARENT_CONTENT      = vim.api.nvim_buf_get_lines(0, isParentTrue - 1, isParentTrue, true)[1]
    local PARENT_INDENT       = string.match(PARENT_CONTENT, '^([ \t]*)')

    ---redefind args
    args.CURRENT_LINE_NUM     = STORE.LAST_NUM
    args.PARENT_LINE          = isParentTrue
    args.LAST_CONTENT         = STORE.LAST_CONTENT

    local isParentOrSibling   = #PARENT_NEXT_INDENT <= #PARENT_INDENT
    if isParentOrSibling then
      M.cekBottomChekbox(args)
    end
  end
end

return M
