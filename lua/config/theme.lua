local M = {}

M.fallback_colorscheme = "catppuccin-mocha"

M.catppuccin = {
  flavour = "mocha",
}

M.transparency = {
  background = true,
  float = true,
}

function M.catppuccin_opts()
  return {
    flavour = M.catppuccin.flavour,
    transparent_background = M.transparency.background,
    float = {
      transparent = M.transparency.float,
    },
  }
end

local BACKGROUND_GROUPS = {
  "Normal",
  "NormalNC",
  "SignColumn",
  "FoldColumn",
  "LineNr",
  "EndOfBuffer",
  "StatusLine",
  "StatusLineNC",
  "TabLine",
  "TabLineFill",
  "TabLineSel",
  "WinBar",
  "WinBarNC",
  "VertSplit",
  "WinSeparator",
}

local FLOAT_GROUPS = {
  "NormalFloat",
  "FloatBorder",
  "FloatTitle",
  "FloatFooter",
  "FloatShadow",
  "FloatShadowThrough",
  "WhichKeyFloat",
  "NotifyBackground",
  "NoicePopup",
  "NoiceConfirm",
  "TelescopeNormal",
  "TelescopeBorder",
  "TelescopePromptNormal",
  "TelescopePromptBorder",
  "TelescopePromptPrefix",
  "TelescopePromptCounter",
  "TelescopePreviewTitle",
  "TelescopeResultsTitle",
  "TelescopeSelection",
  "TelescopeSelectionCaret",
}

local FLOAT_PATTERNS = {
  "^Telescope",
  "^Snacks",
  "^Oil",
  "^Blink",
  "^Cmp",
}

local BACKGROUND_PATTERNS = {
  "^BufferLine",
  "^Lualine",
  "^NeoTree",
  "^NvimTree",
  "^Mason",
  "^Lazy",
}

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

local function clear_bg(groups)
  for _, group in ipairs(groups) do
    hi(group, { bg = "none" })
  end
end

local function clear_bg_patterns(patterns)
  for _, group in ipairs(vim.fn.getcompletion("", "highlight")) do
    for _, pattern in ipairs(patterns) do
      if group:match(pattern) then
        hi(group, { bg = "none" })
        break
      end
    end
  end
end

function M.apply_transparency(opts)
  opts = vim.tbl_extend("force", M.transparency, opts or {})

  if opts.background then
    clear_bg(BACKGROUND_GROUPS)
    clear_bg_patterns(BACKGROUND_PATTERNS)
  end

  if opts.float then
    if vim.o.winblend == 0 then
      clear_bg(FLOAT_GROUPS)
      clear_bg_patterns(FLOAT_PATTERNS)
    end

    if vim.o.pumblend == 0 then
      clear_bg({ "Pmenu", "PmenuBorder", "PmenuKind", "PmenuExtra" })
    end
  end
end

local function wrap_matugen()
  local ok, matugen = pcall(require, "matugen")
  if not ok or matugen._theme_wrapped then
    return
  end

  local orig_setup = matugen.setup
  matugen.setup = function(...)
    orig_setup(...)
    M.apply_transparency()
  end
  matugen._theme_wrapped = true
end

local reload_handler_registered = false
local using_matugen = false

local function has_matugen()
  return vim.fn.filereadable(vim.fn.stdpath("config") .. "/lua/matugen.lua") == 1
end

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
      M.apply_transparency()
    end)
  end))
end

function M.setup()
  if not has_matugen() then
    vim.cmd.colorscheme(M.fallback_colorscheme)
    return
  end

  using_matugen = true
  wrap_matugen()
  register_reload_handler()
  require("matugen").setup()
end

vim.api.nvim_create_autocmd("UIEnter", {
  once = true,
  callback = function()
    if not using_matugen then
      return
    end
    vim.schedule(function()
      M.apply_transparency()
    end)
  end,
})

return M
