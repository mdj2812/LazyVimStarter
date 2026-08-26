local transparency = require("config.transparency")

local M = {}

M.fallback_colorscheme = "catppuccin-mocha"

M.catppuccin = {
  flavour = "mocha",
}

function M.catppuccin_opts()
  return transparency.catppuccin_opts(M.catppuccin.flavour)
end

function M.setup()
  if not transparency.uses_matugen() then
    transparency.set_matugen_active(false)
    vim.cmd.colorscheme(M.fallback_colorscheme)
    return
  end

  transparency.setup_matugen_theme()
end

return M
