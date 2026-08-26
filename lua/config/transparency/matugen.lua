local M = {}

local active = false
local orig_setup = nil
local wrapped = false
local reload_handler_registered = false

function M.is_active()
  return active
end

function M.set_active(is_active)
  active = is_active
end

function M.uses_matugen()
  return vim.fn.filereadable(vim.fn.stdpath("config") .. "/lua/matugen.lua") == 1
end

function M.has_orig_setup()
  return orig_setup ~= nil
end

function M.reload()
  if orig_setup then
    orig_setup()
  end
end

local function wrap(apply_fn)
  local ok, matugen = pcall(require, "matugen")
  if not ok or wrapped then
    return
  end

  orig_setup = matugen.setup
  matugen.setup = function(...)
    apply_fn(...)
  end
  matugen._theme_wrapped = true
  wrapped = true
end

local function register_reload_handler(apply_fn)
  if reload_handler_registered then
    return
  end
  reload_handler_registered = true

  -- Noctalia reloads matugen on SIGUSR1, which drops our setup wrapper.
  -- Register after matugen's handler so transparency is re-applied last.
  local signal = vim.uv.new_signal()
  signal:start(
    "sigusr1",
    vim.schedule_wrap(function()
      vim.schedule(function()
        wrapped = false
        wrap(apply_fn)
        apply_fn()
      end)
    end)
  )
end

function M.setup(apply_fn)
  M.set_active(true)
  wrap(apply_fn)
  register_reload_handler(apply_fn)
  require("matugen").setup()
end

return M
