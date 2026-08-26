local M = {}

function M.set_hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

function M.to_opts(hl)
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

return M
