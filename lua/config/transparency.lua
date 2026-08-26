local M = {}

M.options = {
  background = true,
  float = true,
}

local matugen_active = false
local orig_matugen_setup = nil

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
  "BlinkCmpKindFile",
  "BlinkCmpKindFolder",
  "Pmenu",
  "PmenuBorder",
  "PmenuKind",
  "PmenuExtra",
}

-- base16 does not define these; blink cmdline path completions use them for icons
local BLINK_KIND_GROUPS = {
  BlinkCmpKindFile = "base08",
  BlinkCmpKindFolder = "base0A",
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
  "^NeoTree",
  "^NvimTree",
  "^Mason",
  "^Lazy",
  "^GitSigns",
  "^GitGutter",
  "^lualine_.*_diff_",
}

local DIFF_GROUPS = {
  "DiffAdd",
  "DiffChange",
  "DiffDelete",
  "DiffText",
  "DiffTextAdd",
  "DiffAdded",
  "DiffRemoved",
  "DiffFile",
  "DiffNewFile",
  "DiffLine",
}

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

local function hl_to_opts(hl)
  local opts = {}
  if hl.fg then
    opts.fg = string.format("#%06x", hl.fg)
  end
  if hl.bg then
    opts.bg = string.format("#%06x", hl.bg)
  end
  if hl.sp then
    opts.sp = string.format("#%06x", hl.sp)
  end
  if hl.bold then
    opts.bold = true
  end
  if hl.italic then
    opts.italic = true
  end
  if hl.underline then
    opts.underline = true
  end
  if hl.undercurl then
    opts.undercurl = true
  end
  if hl.strikethrough then
    opts.strikethrough = true
  end
  if hl.reverse then
    opts.reverse = true
  end
  return opts
end

-- nvim_set_hl with only { bg = "none" } clears the whole group; preserve fg and other attrs.
local function clear_bg_group(group)
  local hl = vim.api.nvim_get_hl(0, { name = group, link = true })
  if vim.tbl_isempty(hl) then
    return
  end

  local opts = hl_to_opts(hl)
  opts.bg = "NONE"
  hi(group, opts)
end

local function clear_bg(groups)
  for _, group in ipairs(groups) do
    clear_bg_group(group)
  end
end

local function clear_bg_patterns(patterns)
  for _, group in ipairs(vim.fn.getcompletion("", "highlight")) do
    for _, pattern in ipairs(patterns) do
      if group:match(pattern) then
        clear_bg_group(group)
        break
      end
    end
  end
end

local function ensure_blink_kind_groups()
  local ok, base16 = pcall(require, "base16-colorscheme")
  if not ok or not base16.colors then
    return
  end

  for group, color_key in pairs(BLINK_KIND_GROUPS) do
    hi(group, { fg = base16.colors[color_key], bg = "NONE" })
  end
end

-- Kitty treats cell backgrounds that exactly match the terminal background as
-- transparent when background_opacity is enabled. Nudge by one step so solid
-- mode looks opaque while staying visually indistinguishable.
local function is_kitty()
  return vim.env.KITTY_WINDOW_ID ~= nil or vim.env.TERM == "xterm-kitty"
end

local function nudge_hex(hex)
  if not hex or hex == "NONE" then
    return hex
  end

  local h = hex:gsub("#", ""):lower()
  if #h ~= 6 then
    return hex
  end

  local b = tonumber(h:sub(5, 6), 16)
  if not b then
    return hex
  end

  b = math.min(255, b + 1)
  return string.format("#%s%02x", h:sub(1, 4), b)
end

local function kitty_opaque_nudge_map(transparent_colors)
  local map = {}
  for _, color in ipairs(transparent_colors) do
    map[color:lower()] = nudge_hex(color)
  end
  return map
end

local function nudge_kitty_opaque_group(group, nudge_map)
  local hl = vim.api.nvim_get_hl(0, { name = group, link = true })
  if vim.tbl_isempty(hl) or not hl.bg then
    return
  end

  local bg = string.format("#%06x", hl.bg)
  local nudged = nudge_map[bg:lower()]
  if not nudged then
    return
  end

  local opts = hl_to_opts(hl)
  opts.bg = nudged
  hi(group, opts)
end

local function apply_kitty_opaque_groups(groups, transparent_colors)
  if not is_kitty() then
    return
  end

  local nudge_map = kitty_opaque_nudge_map(transparent_colors)
  for _, group in ipairs(groups) do
    nudge_kitty_opaque_group(group, nudge_map)
  end
end

local function apply_kitty_opaque_patterns(patterns, transparent_colors)
  if not is_kitty() then
    return
  end

  local nudge_map = kitty_opaque_nudge_map(transparent_colors)
  for _, group in ipairs(vim.fn.getcompletion("", "highlight")) do
    for _, pattern in ipairs(patterns) do
      if group:match(pattern) then
        nudge_kitty_opaque_group(group, nudge_map)
        break
      end
    end
  end
end

local function kitty_opaque_colors()
  local ok, base16 = pcall(require, "base16-colorscheme")
  if not ok or not base16.colors or not base16.colors.base00 then
    return nil
  end

  return { base16.colors.base00 }
end

function M.set_matugen_active(active)
  matugen_active = active
end

function M.uses_matugen()
  return vim.fn.filereadable(vim.fn.stdpath("config") .. "/lua/matugen.lua") == 1
end

function M.catppuccin_opts(flavour)
  return {
    flavour = flavour,
    transparent_background = M.options.background,
    float = {
      transparent = M.options.float,
    },
  }
end

local matugen_wrapped = false
local matugen_reload_handler_registered = false

local function wrap_matugen()
  local ok, matugen = pcall(require, "matugen")
  if not ok or matugen_wrapped then
    return
  end

  orig_matugen_setup = matugen.setup
  matugen.setup = function(...)
    M.apply(...)
  end
  matugen._theme_wrapped = true
  matugen_wrapped = true
end

local function register_matugen_reload_handler()
  if matugen_reload_handler_registered then
    return
  end
  matugen_reload_handler_registered = true

  -- Noctalia reloads matugen on SIGUSR1, which drops our setup wrapper.
  -- Register after matugen's handler so transparency is re-applied last.
  local signal = vim.uv.new_signal()
  signal:start(
    "sigusr1",
    vim.schedule_wrap(function()
      vim.schedule(function()
        matugen_wrapped = false
        wrap_matugen()
        M.apply()
      end)
    end)
  )
end

function M.setup_matugen_theme()
  M.set_matugen_active(true)
  wrap_matugen()
  register_matugen_reload_handler()
  require("matugen").setup()
end

function M.lualine_enabled()
  return M.options.background
end

function M.apply(opts)
  if not matugen_active then
    return
  end

  opts = vim.tbl_extend("force", M.options, opts or {})

  if orig_matugen_setup then
    orig_matugen_setup()
  end

  ensure_blink_kind_groups()

  if opts.background then
    clear_bg(BACKGROUND_GROUPS)
    clear_bg(DIFF_GROUPS)
    clear_bg_patterns(BACKGROUND_PATTERNS)
  else
    local opaque_colors = kitty_opaque_colors()
    if opaque_colors then
      apply_kitty_opaque_groups(BACKGROUND_GROUPS, opaque_colors)
      apply_kitty_opaque_groups(DIFF_GROUPS, opaque_colors)
      apply_kitty_opaque_patterns(BACKGROUND_PATTERNS, opaque_colors)
    end
  end

  if opts.float then
    clear_bg(FLOAT_GROUPS)
    clear_bg_patterns(FLOAT_PATTERNS)
  else
    local opaque_colors = kitty_opaque_colors()
    if opaque_colors then
      apply_kitty_opaque_groups(FLOAT_GROUPS, opaque_colors)
      apply_kitty_opaque_patterns(FLOAT_PATTERNS, opaque_colors)
    end
  end

  if opts.background then
    M.refresh_lualine()
  end
end

function M.lualine_component_color(hl_group)
  return function()
    local color = { bg = "NONE" }

    local ok, base16 = pcall(require, "base16-colorscheme")
    if ok and base16.colors then
      color.fg = base16.colors.base05
    end

    if hl_group then
      local hl = vim.api.nvim_get_hl(0, { name = hl_group, link = false })
      if hl.fg then
        color.fg = string.format("#%06x", hl.fg)
      end
    end

    return color
  end
end

function M.lualine_theme()
  local ok, base16 = pcall(require, "base16-colorscheme")
  if not ok or not base16.colors then
    return nil
  end

  local c = base16.colors
  local transparent = "NONE"

  local function mode_a(bg, fg)
    return { bg = bg, fg = fg or c.base00, gui = "bold" }
  end

  local function mode_bc(fg)
    return { bg = transparent, fg = fg or c.base05 }
  end

  return {
    normal = {
      a = mode_a(c.base0D),
      b = mode_bc(c.base0D),
      c = mode_bc(c.base05),
    },
    insert = {
      a = mode_a(c.base0B),
      b = mode_bc(c.base0B),
      c = mode_bc(c.base05),
    },
    visual = {
      a = mode_a(c.base0E),
      b = mode_bc(c.base0E),
      c = mode_bc(c.base05),
    },
    replace = {
      a = mode_a(c.base08),
      b = mode_bc(c.base08),
      c = mode_bc(c.base05),
    },
    command = {
      a = mode_a(c.base0A),
      b = mode_bc(c.base0A),
      c = mode_bc(c.base05),
    },
    terminal = {
      a = mode_a(c.base0B),
      b = mode_bc(c.base0B),
      c = mode_bc(c.base05),
    },
    inactive = {
      a = mode_bc(c.base04),
      b = mode_bc(c.base03),
      c = mode_bc(c.base03),
    },
  }
end

function M.refresh_lualine()
  if not matugen_active or not M.lualine_enabled() or not package.loaded["lualine"] then
    return
  end

  local theme = M.lualine_theme()
  if not theme then
    return
  end

  require("lualine.highlight").create_highlight_groups(theme)
  require("lualine").refresh({ force = true })
end

local function schedule_apply()
  if not matugen_active then
    return
  end
  vim.schedule(M.apply)
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
