return {
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      require("telescope").setup({
        defaults = {
          path_display = {
            "smart",
          },
        },
      })
    end,
  },
}
