return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {

    explorer = { enabled = true, replace_netrw = true },
    picker = {
      sources = {
        explorer = {
          hidden = true,
          ignored = true,
          replace_netrw = true,
        },
        files = {
          hidden = true,
          ignored = true,
          exclude = { "node_modules", "dist", ".git" },
        },
      },
    },
  },
}
