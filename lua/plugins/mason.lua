return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "clangd",
        "clang-format",
        "cmakelint",
        "cmakelang",
        "codespell",
        "codelldb",
        "debugpy",
      },
    },
  },
}
