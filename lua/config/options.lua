-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.lazyvim_python_lsp = "pyright"
vim.g.lazyvim_python_ruff = "ruff"

local osc52_copy = require("vim.ui.clipboard.osc52").copy("+")
local cache = { { "" }, "v" }

local function copy(lines, regtype)
  cache = { vim.deepcopy(lines), regtype }
  osc52_copy(lines)
end

local function paste()
  return vim.deepcopy(cache)
end

vim.g.clipboard = {
  name = "OSC 52",
  copy = { ["+"] = copy, ["*"] = copy },
  paste = { ["+"] = paste, ["*"] = paste },
}
