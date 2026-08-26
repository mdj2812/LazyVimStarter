local colors = require("config.transparency.colors")
local groups = require("config.transparency.groups")
local hl_util = require("config.transparency.hl")
local kitty = require("config.transparency.kitty")

local M = {}

-- nvim_set_hl with only { bg = "none" } clears the whole group; preserve fg and other attrs.
local function clear_bg_group(group)
  local highlight = vim.api.nvim_get_hl(0, { name = group, link = true })
  if vim.tbl_isempty(highlight) then
    return
  end

  local opts = hl_util.to_opts(highlight)
  opts.bg = "NONE"
  hl_util.set_hl(group, opts)
end

local function clear_bg(group_list)
  for _, group in ipairs(group_list) do
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

function M.ensure_blink_kind_groups(flavour)
  local base16 = colors.base16()
  if base16 then
    for group, color_key in pairs(groups.BLINK_KIND_GROUPS) do
      hl_util.set_hl(group, { fg = base16[color_key], bg = "NONE" })
    end
    return
  end

  local palette = colors.catppuccin_palette(flavour)
  if not palette then
    return
  end

  for group, color_key in pairs(groups.CATPPUCCIN_BLINK_KIND_GROUPS) do
    hl_util.set_hl(group, { fg = palette[color_key], bg = "NONE" })
  end
end

function M.apply_transparency(enabled, group_list, patterns, opaque_flavour)
  if enabled then
    clear_bg(group_list)
    if patterns then
      clear_bg_patterns(patterns)
    end
    return
  end

  local opaque_colors = kitty.opaque_colors(opaque_flavour)
  if opaque_colors then
    kitty.apply_opaque(group_list, patterns, opaque_colors)
  end
end

return M
