return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        cmakelint = {
          cmd = "cmakelint",
          stdin = true,
          args = { "--line-width", "120" },
          stream = "stdout",
        },
      },
    },
  },
}
