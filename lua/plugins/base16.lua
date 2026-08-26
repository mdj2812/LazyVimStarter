return {
  "RRethy/base16-nvim",
  enabled = function()
    return vim.fn.filereadable(vim.fn.stdpath("config") .. "/lua/matugen.lua") == 1
  end,
  priority = 1000,
  lazy = false,
}
