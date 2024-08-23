return {
  "HakonHarnes/img-clip.nvim",
  event = "VeryLazy",
  opts = {
    -- add options here
    default = {
      dir_path = function()
        return vim.fn.expand("%:p:h")
      end,
    },
    -- or leave it empty to use the default settings
  },
  -- keys = {
  -- suggested keymap
  -- { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
  -- },
}
