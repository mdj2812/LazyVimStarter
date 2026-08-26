local M = {}

M.options = {
  background = true,
  float = true,
}

local matugen_active = false

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

function M.set_matugen_active(active)
  matugen_active = active
end

function M.apply(opts)
  if not matugen_active then
    return
  end

  opts = vim.tbl_extend("force", M.options, opts or {})

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

  M.refresh_lualine()
end

function M.lualine_component_color()
  local ok, base16 = pcall(require, "base16-colorscheme")
  if ok and base16.colors then
    return { fg = base16.colors.base05, bg = "NONE" }
  end
  return { bg = "NONE" }
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
  if not matugen_active or not package.loaded["lualine"] then
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

return M
