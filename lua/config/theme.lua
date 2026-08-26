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
    transparency.setup_fallback_theme(M.fallback_colorscheme, M.catppuccin.flavour)
    return
  end

  transparency.setup_matugen_theme()
end

return M
