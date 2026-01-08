return {
  "stevearc/oil.nvim",
  opts = {
    columns = {
      "icon",
      -- "permissions",
      -- "size",
      -- "mtime",
    },
    float = {
      border = "rounded",
    },
    watch_for_changes = true,
  },
  -- Optional dependencies
  dependencies = { { "nvim-mini/mini.icons", opts = {} } },
}
