local colors = require("config.transparency.colors")

local M = {}

function M.component_color(hl_group)
  return function()
    local color = { bg = "NONE" }
    local base16 = colors.base16()
    if base16 then
      color.fg = base16.base05
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

function M.theme()
  local base16 = colors.base16()
  if not base16 then
    return nil
  end

  local function mode_a(bg, fg)
    return { bg = bg, fg = fg or base16.base00, gui = "bold" }
  end

  local function mode_bc(fg)
    return { bg = "NONE", fg = fg or base16.base05 }
  end

  return {
    normal = {
      a = mode_a(base16.base0D),
      b = mode_bc(base16.base0D),
      c = mode_bc(base16.base05),
    },
    insert = {
      a = mode_a(base16.base0B),
      b = mode_bc(base16.base0B),
      c = mode_bc(base16.base05),
    },
    visual = {
      a = mode_a(base16.base0E),
      b = mode_bc(base16.base0E),
      c = mode_bc(base16.base05),
    },
    replace = {
      a = mode_a(base16.base08),
      b = mode_bc(base16.base08),
      c = mode_bc(base16.base05),
    },
    command = {
      a = mode_a(base16.base0A),
      b = mode_bc(base16.base0A),
      c = mode_bc(base16.base05),
    },
    terminal = {
      a = mode_a(base16.base0B),
      b = mode_bc(base16.base0B),
      c = mode_bc(base16.base05),
    },
    inactive = {
      a = mode_bc(base16.base04),
      b = mode_bc(base16.base03),
      c = mode_bc(base16.base03),
    },
  }
end

function M.refresh(matugen_active, enabled)
  if not matugen_active or not enabled or not package.loaded["lualine"] then
    return
  end

  local theme = M.theme()
  if not theme then
    return
  end

  require("lualine.highlight").create_highlight_groups(theme)
  require("lualine").refresh({ force = true })
end

return M
