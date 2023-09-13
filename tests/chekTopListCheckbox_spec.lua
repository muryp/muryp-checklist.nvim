local chekTopListCheckbox = require('muryp-checklist.chekTopListCheckbox')

describe('get unchecked parent on ', function()
  vim.cmd('e! ./example/list.txt')
  _G.space_opts()
  local testCase = {
    { 1, false },
    { 3, 2 },
    { 5, 4 },
    { 7, 6 },
    { 10, false },
    { 23, false },
    { 31, false },
    { 34, false },
  }
  for _, val in pairs(testCase) do
    it('line : ' .. val[1], function()
      local result = chekTopListCheckbox(val[1], true)
      if val[2] ~= result then
        error('expect : ' .. val[2] .. ' but have : ' .. result)
      end
    end)
  end
end)
describe('get checked parent on ', function()
  vim.cmd('e! ./example/list.txt')
  _G.space_opts()
  local testCase = {
    { 1, false },
    { 10, 9 },
    { 12, 11 },
    { 14, false },
    { 16, false },
    { 23, false },
    { 31, false },
    { 34, false },
  }
  for _, val in pairs(testCase) do
    it('line : ' .. val[1], function()
      local result = chekTopListCheckbox(val[1], false)
      if val[2] ~= result then
        error('expect : ' .. val[2] .. ' but have : ' .. result)
      end
    end)
  end
end)