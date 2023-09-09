vim.opt.runtimepath:append(".")
vim.opt.runtimepath:append("./plenary.nvim")
_G.space_opts = function()
  vim.opt.tabstop = 2
  vim.opt.softtabstop = 2
  vim.opt.shiftwidth = 2
end
_G.tab_opts = function()
  vim.opt.tabstop = 2
  vim.opt.softtabstop = 2
end

_G.space_opts()
require('plenary.test_harness').test_directory('lua/test')