-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

require("markdown-utils")
require("markdown-toc")

vim.opt.swapfile = false
vim.g.snacks_animate = false

vim.g.moonflyTransparent = true
vim.g.moonflyCursorColor = true
vim.g.moonflyUnderlineMatchParen = true
