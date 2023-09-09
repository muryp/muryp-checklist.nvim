return function(CONTEN_LINE)
  local shiftwidth = vim.api.nvim_buf_get_option(0, 'shiftwidth') ---@type number
  local softtabstop = vim.api.nvim_buf_get_option(0, 'softtabstop') / 2 ---@type number
  if CONTEN_LINE == nil then
    CONTEN_LINE = vim.api.nvim_get_current_line()
  end
  local indent_char = string.match(CONTEN_LINE, '^([ \t]*)')

  if indent_char then
    local indent_size
    if indent_char:match('\t') then
      -- use tab characters
      local tab = indent_char:gsub(' ', '') -- remove space characters
      indent_size = #tab / softtabstop      -- count result tab / opts tab width
    else
      -- use space
      local spaces = indent_char:gsub('\t', '') -- remove tab characters
      indent_size = #spaces / shiftwidth        -- count result space / opts space width
    end

    return indent_size
  else
    return 0 -- if space and tab not found
  end
end
