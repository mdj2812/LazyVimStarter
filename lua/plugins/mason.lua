return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "clangd",
        "clang-format",
        "codespell",
        "codelldb",
        "python-lsp-server",
      },
    },
  },
}
