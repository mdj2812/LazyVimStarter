return {
  -- { "ellisonleao/gruvbox.nvim" },

  {
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      style = "night",
      transparent = true,
    },
  },

  -- {
  --   "scottmckendry/cyberdream.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("cyberdream").setup({
  --       -- Recommended - see "Configuring" below for more config options
  --       transparent = true,
  --       italic_comments = true,
  --       hide_fillchars = true,
  --       borderless_telescope = true,
  --       terminal_colors = true,
  --     })
  --   end,
  -- },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
