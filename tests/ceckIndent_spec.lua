local cekIndent = require('muryp-checklist.cekIndent')

local ListTest = {
  tab = _G.tab_opts,
  space = _G.space_opts
}

for typeMode, opts in pairs(ListTest) do
  describe('cek indent with ' .. typeMode .. ' on ', function()
    vim.cmd('e! ./example/indent.txt')
    opts()
    -- _G.space_opts()
    local CONTENT = vim.api.nvim_buf_get_lines(0, 0, -1, false) ---@type string[]
    for i = 1, 5, 1 do
      it('line : ' .. i, function()
        local cekLine = cekIndent(CONTENT[i]).indent_size
        print('expect : ' .. i - 1)
        print('result : ' .. cekLine)
        if cekLine ~= i - 1 then
          error('expect : ' .. i - 1 .. ' but get :' .. cekLine)
        end
      end)
    end
  end)
end