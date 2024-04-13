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
        "gersemi",
        "codespell",
        "codelldb",
        "python-lsp-server",
      },
    },
  },
}
