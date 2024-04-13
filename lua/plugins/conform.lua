return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        cpp = { "clang-format" },
        cmake = { "gersemi" },
        lua = { "stylua" },
        python = { "isort", "autopep8" },
        json = { "jq" },
        ["*"] = { "codespell" },
        ["_"] = { "trim_whitespace" },
      },
      formatters = {
        autopep8 = {
          args = { "--in-place", "--max-line-length", "120", "-aa", "$FILENAME" },
          stdin = false,
        },
        jq = {
          args = { "--indent", "4" },
        },
      },
    },
  },
}
