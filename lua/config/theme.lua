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

-- base16 does not define File/Folder kinds; blink cmdline path completions use them for icons
local function apply_blink_kinds()
  local ok, base16 = pcall(require, "base16-colorscheme")
  if not ok or not base16.colors then
    return
  end

  local c = base16.colors
  vim.api.nvim_set_hl(0, "BlinkCmpKindFile", { fg = c.base08, bg = "NONE" })
  vim.api.nvim_set_hl(0, "BlinkCmpKindFolder", { fg = c.base0A, bg = "NONE" })
end

local function after_matugen_setup()
  transparency.apply()
  apply_blink_kinds()
end

local function wrap_matugen()
  local ok, matugen = pcall(require, "matugen")
  if not ok or matugen._theme_wrapped then
    return
  end

  local orig_setup = matugen.setup
  matugen.setup = function(...)
    orig_setup(...)
    after_matugen_setup()
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
      after_matugen_setup()
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
