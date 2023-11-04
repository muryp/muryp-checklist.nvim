---@param CONTEN_LINE string|nil
---@return { indent_size : number, shiftwidth : number, softtabstop : number, isTab : number } | nil
return function(CONTEN_LINE)
  local shiftwidth = vim.api.nvim_buf_get_option(0, 'shiftwidth') ---@type number
  local softtabstop = vim.api.nvim_buf_get_option(0, 'softtabstop') / 2 ---@type number
  if CONTEN_LINE == nil then
    CONTEN_LINE = vim.api.nvim_get_current_line() ---@type string
  end
  local indent_char = string.match(CONTEN_LINE, '^([ \t]*)')
  local isTab = false

  if indent_char then
    local indent_size
    if indent_char:match '\t' then
      -- use tab characters
      local tab = indent_char:gsub(' ', '') -- remove space characters
      indent_size = #tab / softtabstop -- count result tab / opts tab width
      isTab = true
    else
      -- use space
      local spaces = indent_char:gsub('\t', '') -- remove tab characters
      indent_size = #spaces / shiftwidth -- count result space / opts space width
    end

    return {
      indent_size = indent_size,
      shiftwidth = shiftwidth,
      softtabstop = softtabstop,
      isTab = isTab,
    }
  end
end
