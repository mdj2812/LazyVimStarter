local fallback = require("config.transparency.fallback")
local groups = require("config.transparency.groups")
local highlights = require("config.transparency.highlights")
local lualine = require("config.transparency.lualine")
local matugen = require("config.transparency.matugen")

local M = {}

M.options = {
  background = true,
  float = true,
}

local function active()
  return matugen.is_active() or fallback.is_active()
end

local function schedule_apply()
  if not active() then
    return
  end
  vim.schedule(M.apply)
end

function M.uses_matugen()
  return matugen.uses_matugen()
end

function M.catppuccin_opts(flavour)
  return fallback.catppuccin_opts(M.options, flavour)
end

function M.setup_fallback_theme(colorscheme, flavour)
  matugen.set_active(false)
  fallback.set_active(true, colorscheme, flavour)
  M.apply()
end

function M.setup_matugen_theme()
  matugen.setup(M.apply)
end

function M.lualine_enabled()
  return M.options.background
end

function M.lualine_theme()
  return lualine.theme()
end

function M.lualine_component_color(hl_group)
  return lualine.component_color(hl_group)
end

function M.refresh_lualine()
  lualine.refresh(matugen.is_active(), M.lualine_enabled())
end

function M.apply(opts)
  if not active() then
    return
  end

  opts = vim.tbl_extend("force", M.options, opts or {})

  if fallback.is_active() then
    fallback.reload(opts)
  elseif matugen.has_orig_setup() then
    matugen.reload()
  end

  local flavour = fallback.get_flavour()
  highlights.ensure_blink_kind_groups(flavour)

  highlights.apply_transparency(opts.background, groups.BACKGROUND_GROUPS, groups.BACKGROUND_PATTERNS, flavour)
  highlights.apply_transparency(opts.background, groups.DIFF_GROUPS, nil, flavour)
  highlights.apply_transparency(opts.float, groups.FLOAT_GROUPS, groups.FLOAT_PATTERNS, flavour)

  if opts.background then
    M.refresh_lualine()
  end
end

vim.api.nvim_create_autocmd("UIEnter", {
  once = true,
  callback = schedule_apply,
})

-- Lualine loads on VeryLazy, after UIEnter.
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = schedule_apply,
})

-- Gitsigns loads on first file open, after VeryLazy.
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  once = true,
  callback = schedule_apply,
})

return M
