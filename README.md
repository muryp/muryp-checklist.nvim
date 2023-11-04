[![License: Apache](https://img.shields.io/badge/License-Apache-blue.svg)](https://opensource.org/licenses/Apache-2.0)
![Neovim version](https://img.shields.io/badge/Neovim-0.8.x-green.svg)
![Lua version](https://img.shields.io/badge/Lua-5.4-yellow.svg)
[![Repo Size](https://img.shields.io/github/repo-size/muryp/muryp-checklist.nvim)](https://github.com/muryp/muryp-checklist.nvim)
[![Downloads](https://img.shields.io/github/downloads/muryp/muryp-checklist.nvim/total)](https://github.com/muryp/muryp-checklist.nvim/releases)
[![Latest Release](https://img.shields.io/github/release/muryp/muryp-checklist.nvim)](https://github.com/muryp/muryp-checklist.nvim/releases/latest)
[![Last Commit](https://img.shields.io/github/last-commit/muryp/muryp-checklist.nvim)](https://github.com/muryp/muryp-checklist.nvim/commits/master)
[![Open Issues](https://img.shields.io/github/issues/muryp/muryp-checklist.nvim)](https://github.com/muryp/muryp-checklist.nvim/issues)

# Plugin Nvim MuryP Git
easy use git and git issue in nvim, with telescope.
## feature
- toggle checklist markdown checkbox
## requirement
- nvim 0.8+ (recommendation)
## install
- packer
```lua
use {
  'muryp/muryp-checklist.nvim',
  config = function()
    require('muryp-checklist').setup({})
  end
}
```
## setup
```lua
require('muryp-checklist').setup({ map = "<leader>'", fileExt = { "*.ext", "*.ext2" } })
```