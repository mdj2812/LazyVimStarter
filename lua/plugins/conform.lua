return {
  {
    "stevearc/conform.nvim",
    opts = {
      default_format_opts = {
        timeout_ms = 10000,
      },
      formatters_by_ft = {
        cpp = { "clang-format" },
        cuda = { "clang-format" },
        cmake = { "cmake_format" },
        lua = { "stylua" },
        python = { "isort", "autopep8" },
        json = { "jq" },
        yaml = { "yamlfmt" },
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
