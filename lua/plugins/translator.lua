return {
  "uga-rosa/translate.nvim",
  event = "VeryLazy",
  config = function()
    require("translate").setup({
      -- Optional: configure your preferred settings here
      default = {
        command = "google", -- or "google" or "deepl"
        output = "floating", -- floating | split | insert | replace | register
      },
    })

    -- Keymaps (normal and visual mode)
    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }

    vim.keymap.set(
      { "n", "v" },
      "<leader>ten",
      ":Translate -source=PT -target=EN -output=floating<CR>",
      { noremap = true, silent = true }
    )

    -- en → pt
    vim.keymap.set(
      { "n", "v" },
      "<leader>tep",
      ":Translate -source=EN -target=PT -output=floating<CR>",
      { noremap = true, silent = true }
    )

    -- Replace selected text with translation
    map({ "n", "v" }, "<leader>tr", ":Translate EN -output=replace<CR>", opts)
  end,
}
