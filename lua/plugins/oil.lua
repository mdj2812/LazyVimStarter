return {
  "stevearc/oil.nvim",
  opts = {
    columns = {
      "icon",
      "permissions",
      "size",
      "mtime",
    },
    win_options = {
      wrap = true,
      list = true,
    },
    experimental_watch_for_changes = true,
  },
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
