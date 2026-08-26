local kitty = require("config.transparency.kitty")

local M = {}

local active = false
local colorscheme = nil
local flavour = "mocha"

function M.is_active()
  return active
end

function M.get_flavour()
  return flavour
end

function M.set_active(is_active, cs, f)
  active = is_active
  if cs then
    colorscheme = cs
  end
  if f then
    flavour = f
  end
end

function M.catppuccin_opts(options, f)
  return {
    flavour = f or flavour,
    transparent_background = options.transparent,
    kitty = kitty.is_kitty(),
    float = {
      transparent = options.transparent,
    },
  }
end

function M.reload(options)
  local ok, catppuccin = pcall(require, "catppuccin")
  if ok then
    catppuccin.setup(M.catppuccin_opts(options, flavour))
  end

  if colorscheme then
    vim.cmd.colorscheme(colorscheme)
  end
end

return M
