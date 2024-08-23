-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- vim.api.nvim_create_autocmd("filetype", {
--   group = "setIndent",
--   pattern = { "markdown" },
--   command = "setlocal colorcolum=80",
-- })

-- vim.api.nvim_create_autocmd({
--   "BufWinEnter",
-- }, {
--   pattern = "*.md",
--   -- callback = function()
--   --   vim.opt.colorcolumn = "80"
--   -- end,
--   command = "setlocal colorcolumn=80",
-- })

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  pattern = { "*.md", "*.mdx" },
  desc = "Enable deadcolumn when enter in a Markdown file",
  command = "setlocal colorcolumn=80",
})
