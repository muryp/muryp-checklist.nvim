local toggleCheckbox = require('muryp-checklist').toggleCheck
local chekTopListCheckbox = require('muryp-checklist.chekTopListCheckbox')

describe('get unchecked parent on ', function()
  vim.cmd('e! ./example/list.txt')
  _G.space_opts()
  local testCase = {
    { 1,  false },
    { 3,  2 },
    { 5,  4 },
    { 7,  6 },
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
    { 1,  false },
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


--togle checkbox / test e2e
describe('Toggle checkbox on ', function()
  vim.cmd('e! ./example/list.txt')
  _G.space_opts()
  it('line : 1', function()
    local CONTENT_BEFORE = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    CONTENT_BEFORE[1] = '- [x] Task 1'
    CONTENT_BEFORE = table.concat(CONTENT_BEFORE, "\n") ---@type string
    toggleCheckbox()
    local CONTENT_AFTER = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    CONTENT_AFTER = table.concat(CONTENT_AFTER, "\n") ---@type string
    if CONTENT_AFTER ~= CONTENT_BEFORE then
      error('not match')
    end
  end)
  it('line : 2', function()
    local CONTENT_BEFORE = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    CONTENT_BEFORE[2] = '- [x] Task 2 :'
    CONTENT_BEFORE[3] = '  - [x] Subtask 1'
    CONTENT_BEFORE[4] = '  - [x] Subtask 2 :'
    CONTENT_BEFORE[5] = '    - [x] Sub-subtask 1'
    CONTENT_BEFORE[6] = '    - [x] Sub-subtask 2 :'
    CONTENT_BEFORE[7] = '      - [x] SUB-Sub-subtask 1'
    CONTENT_BEFORE[8] = '      - [x] SUB-Sub-subtask 2'
    CONTENT_BEFORE = table.concat(CONTENT_BEFORE, "\n") ---@type string
    vim.cmd('normal! 2G')
    toggleCheckbox()
    local CONTENT_AFTER = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    CONTENT_AFTER = table.concat(CONTENT_AFTER, "\n") ---@type string
    if CONTENT_AFTER ~= CONTENT_BEFORE then
      error('not match')
    end
  end)
  it('line : 6', function()
    local CONTENT_BEFORE = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    CONTENT_BEFORE[2] = '- [ ] Task 2 :'
    CONTENT_BEFORE[3] = '  - [x] Subtask 1'
    CONTENT_BEFORE[4] = '  - [ ] Subtask 2 :'
    CONTENT_BEFORE[5] = '    - [x] Sub-subtask 1'
    CONTENT_BEFORE[6] = '    - [ ] Sub-subtask 2 :'
    CONTENT_BEFORE[7] = '      - [ ] SUB-Sub-subtask 1'
    CONTENT_BEFORE[8] = '      - [ ] SUB-Sub-subtask 2'
    CONTENT_BEFORE = table.concat(CONTENT_BEFORE, "\n") ---@type string
    vim.cmd('normal! 6G')
    toggleCheckbox()
    local CONTENT_AFTER = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    CONTENT_AFTER = table.concat(CONTENT_AFTER, "\n") ---@type string
    if CONTENT_AFTER ~= CONTENT_BEFORE then
      error('not match')
    end
  end)
  it('line : 7 and 8', function()
    local CONTENT_BEFORE = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    CONTENT_BEFORE[2] = '- [x] Task 2 :'
    CONTENT_BEFORE[3] = '  - [x] Subtask 1'
    CONTENT_BEFORE[4] = '  - [x] Subtask 2 :'
    CONTENT_BEFORE[5] = '    - [x] Sub-subtask 1'
    CONTENT_BEFORE[6] = '    - [x] Sub-subtask 2 :'
    CONTENT_BEFORE[7] = '      - [x] SUB-Sub-subtask 1'
    CONTENT_BEFORE[8] = '      - [x] SUB-Sub-subtask 2'
    CONTENT_BEFORE = table.concat(CONTENT_BEFORE, "\n") ---@type string
    vim.cmd('normal! 7G')
    toggleCheckbox()
    vim.cmd('normal! 8G')
    toggleCheckbox()
    local CONTENT_AFTER = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    CONTENT_AFTER = table.concat(CONTENT_AFTER, "\n") ---@type string
    if CONTENT_AFTER ~= CONTENT_BEFORE then
      error('not match')
    end
  end)
  it('line : 31', function()
    local CONTENT_BEFORE = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    CONTENT_BEFORE[31] = '    - [ ] not sub-subtask1'
    CONTENT_BEFORE = table.concat(CONTENT_BEFORE, "\n") ---@type string
    vim.cmd('normal! 31G')
    toggleCheckbox()
    local CONTENT_AFTER = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    CONTENT_AFTER = table.concat(CONTENT_AFTER, "\n") ---@type string
    if CONTENT_AFTER ~= CONTENT_BEFORE then
      error('not match')
    end
  end)
end)