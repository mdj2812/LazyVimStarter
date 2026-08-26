return {
  "catppuccin/nvim",
  name = "catppuccin",
  opts = function()
    return require("config.theme").catppuccin_opts()
  end,
}
