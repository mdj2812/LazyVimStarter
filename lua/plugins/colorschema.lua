return {
  -- { "ellisonleao/gruvbox.nvim" },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = true,
      float = {
        transparent = true,
        solid = true,
      },
    },
  },

  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = true,
  --   priority = 1000,
  --   opts = {
  --     style = "storm",
  --     transparent = true,
  --   },
  -- },

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
      colorscheme = "catppuccin",
    },
  },
}
