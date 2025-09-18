return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "clangd",
        "clang-format",
        "cmakelint",
        "codespell",
        "codelldb",
        "debugpy",
      },
      ui = {
        border = "rounded",
      },
    },
  },
}
