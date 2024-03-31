-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Enable copy paste for wayland using wl-clipboard
-- ================================================
-- WL CLIPBOARD CONFIGURATION
-- ================================================
-- if vim.fn.executable("wl-copy") == 0 then
--   print("wl-clipboard not found, clipboard integration won't work")
-- else
--   vim.g.clipboard = {
--     name = "wl-clipboard (wsl)",
--     copy = {
--       ["+"] = 'wl-copy --foreground --type text/plain',
--       ["*"] = 'wl-copy --foreground --primary --type text/plain',
--     },
--     paste = {
--       ["+"] = (function()
--         return vim.fn.systemlist('wl-paste --no-newline|sed -e "s/\r$//"', { '' }, 1) -- '1' keeps empty lines
--       end),
--       ["*"] = (function()
--         return vim.fn.systemlist('wl-paste --primary --no-newline|sed -e "s/\r$//"', { '' }, 1)
--       end),
--     },
--     cache_enabled = true
--   }
-- end
--
if vim.g.neovide then
  vim.cmd([[
    nmap <c-c> "+y
    vmap <c-c> "+y
    nmap <c-v> "+p
    inoremap <c-v> <c-r>+
    cnoremap <c-v> <c-r>+
    inoremap <c-r> <c-v>
  ]])
end
