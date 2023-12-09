local addList = require 'muryp-checklist.addList'
describe('add List if ', function()
  vim.cmd 'e! test.txt'
  _G.space_opts()
  local bufnr = vim.api.nvim_get_current_buf()
  it('with text, without :', function()
    local LINE_NUMBER = 1
    local TEXT_TODO = '- [ ] Todo 1'
    vim.api.nvim_buf_set_lines(bufnr, LINE_NUMBER - 1, LINE_NUMBER, false, { TEXT_TODO })
    addList()
    local CONTENT_FILE = vim.api.nvim_buf_get_lines(0, 0, -1, false) ---@type string[]
    _G.test(CONTENT_FILE[1], TEXT_TODO)
    _G.test(CONTENT_FILE[2], '- [ ] ')
  end)
  it('with text, with :', function()
    local LINE_NUMBER = vim.api.nvim_win_get_cursor(0)[1]
    local TEXT_TODO = '- [ ] Todo 2 :'
    vim.api.nvim_buf_set_lines(bufnr, LINE_NUMBER - 1, LINE_NUMBER, false, { TEXT_TODO })
    addList()
    local CONTENT_FILE = vim.api.nvim_buf_get_lines(0, 0, -1, false) ---@type string[]
    _G.test(CONTENT_FILE[2], TEXT_TODO)
    _G.test(CONTENT_FILE[3], '  - [ ] ')
  end)
  it('no text, indent 1', function()
    addList()
    local CONTENT_FILE = vim.api.nvim_buf_get_lines(0, 0, -1, false) ---@type string[]
    _G.test(CONTENT_FILE[3], '- [ ] ')
  end)
  it('no text, indent 0', function()
    addList()
    local CONTENT_FILE = vim.api.nvim_buf_get_lines(0, 0, -1, false) ---@type string[]
    _G.test(CONTENT_FILE[3], '')
  end)
end)
