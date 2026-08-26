local M = {}

function M.base16()
  local ok, base16 = pcall(require, "base16-colorscheme")
  if not ok or not base16.colors then
    return nil
  end
  return base16.colors
end

function M.catppuccin_palette(flavour)
  local ok, palette = pcall(require, "catppuccin.palettes." .. flavour)
  if not ok or not palette then
    return nil
  end
  return palette
end

return M
