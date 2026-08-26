local transparency = require("config.transparency")

local M = {}

M.fallback_colorscheme = "catppuccin-mocha"

M.catppuccin = {
  flavour = "mocha",
}

function M.catppuccin_opts()
  return {
    flavour = M.catppuccin.flavour,
    transparent_background = transparency.options.background,
    float = {
      transparent = transparency.options.float,
    },
  }
end

function M.uses_matugen()
  return vim.fn.filereadable(vim.fn.stdpath("config") .. "/lua/matugen.lua") == 1
end

local function wrap_matugen()
  local ok, matugen = pcall(require, "matugen")
  if not ok or matugen._theme_wrapped then
    return
  end

  local orig_setup = matugen.setup
  matugen.setup = function(...)
    orig_setup(...)
    transparency.apply()
  end
  matugen._theme_wrapped = true
end

local reload_handler_registered = false

local function register_reload_handler()
  if reload_handler_registered then
    return
  end
  reload_handler_registered = true

  -- Noctalia reloads matugen on SIGUSR1, which drops our setup wrapper.
  -- Register after matugen's handler so transparency is re-applied last.
  local signal = vim.uv.new_signal()
  signal:start("sigusr1", vim.schedule_wrap(function()
    vim.schedule(function()
      wrap_matugen()
      transparency.apply()
    end)
  end))
end

function M.setup()
  if not M.uses_matugen() then
    transparency.set_matugen_active(false)
    vim.cmd.colorscheme(M.fallback_colorscheme)
    return
  end

  transparency.set_matugen_active(true)
  wrap_matugen()
  register_reload_handler()
  require("matugen").setup()
end

return M
