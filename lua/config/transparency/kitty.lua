local colors = require("config.transparency.colors")
local hl_util = require("config.transparency.hl")

local M = {}

function M.is_kitty()
  return vim.env.KITTY_WINDOW_ID ~= nil or vim.env.TERM == "xterm-kitty"
end

-- Kitty treats cell backgrounds that exactly match the terminal background as
-- transparent when background_opacity is enabled. Nudge by one step so solid
-- mode looks opaque while staying visually indistinguishable.
function M.nudge_hex(hex)
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

local function nudge_opaque_group(group, nudge_map)
  local highlight = vim.api.nvim_get_hl(0, { name = group, link = true })
  if vim.tbl_isempty(highlight) or not highlight.bg then
    return
  end

  local bg = string.format("#%06x", highlight.bg)
  local nudged = nudge_map[bg:lower()]
  if not nudged then
    return
  end

  local opts = hl_util.to_opts(highlight)
  opts.bg = nudged
  hl_util.set_hl(group, opts)
end

function M.apply_opaque(groups, patterns, transparent_colors)
  if not M.is_kitty() then
    return
  end

  local nudge_map = {}
  for _, color in ipairs(transparent_colors) do
    nudge_map[color:lower()] = M.nudge_hex(color)
  end

  for _, group in ipairs(groups) do
    nudge_opaque_group(group, nudge_map)
  end

  if patterns then
    for _, group in ipairs(vim.fn.getcompletion("", "highlight")) do
      for _, pattern in ipairs(patterns) do
        if group:match(pattern) then
          nudge_opaque_group(group, nudge_map)
          break
        end
      end
    end
  end
end

function M.opaque_colors(flavour)
  local base16 = colors.base16()
  if base16 and base16.base00 then
    return { base16.base00 }
  end

  local palette = colors.catppuccin_palette(flavour)
  if palette and palette.base then
    return { palette.base }
  end

  return nil
end

return M
