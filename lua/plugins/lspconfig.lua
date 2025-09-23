return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "-j=8",
            "--offset-encoding=utf-16",
            "--clang-tidy",
            "--malloc-trim",
            "--background-index",
            "--pch-storage=memory",
          },
        },
      },
      diagnostics = {
        float = {
          border = "rounded",
        },
      },
    },
  },
}
