local isCeklist = function(line)
  return string.find(line, "^%s*%-[ ]%[[%s|x]%]")
end
---this function for
---@param GET_CURRENT_LINE string string line
---@return string | nil TOGGLE_CHECKBOX will be checked/unchecked if string contain ceckbox
return function(GET_CURRENT_LINE)
  if isCeklist(GET_CURRENT_LINE) then
    local toggleCheck = string.gsub(GET_CURRENT_LINE, "%[([%s|x])%]", function(match)
      return match == " " and "[x]" or "[ ]"
    end)
    return toggleCheck
  end
end
