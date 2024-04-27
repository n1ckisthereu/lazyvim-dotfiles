return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_by_name = {
          ".git",
        },
        never_show = { ".git" },
      },
    },
    default_component_configs = {
      container = {
        enable_character_fade = true,
      },
      icon = {
        default = "",
        highlight = "NeoTreeFileIcon",
      },
    },
  },
}
