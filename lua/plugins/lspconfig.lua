return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                -- formatter options
                black = { enabled = false },
                autopep8 = { enabled = false },
                yapf = { enabled = false },
                flake8 = { enabled = true },
                -- linter options
                pylint = { enabled = true, args = { "--max-line-length", "120" } },
                pyflakes = { enabled = false },
                pycodestyle = { enabled = false },
                -- type checker
                pylsp_mypy = { enabled = true },
                -- auto-completion options
                jedi_completion = { fuzzy = true },
                -- import sorting
                pyls_isort = { enabled = true },
              },
            },
          },
        },
        clangd = {
          cmd = {
            "clangd",
            "-j=8",
            "--offset-encoding=utf-16",
            "--clang-tidy",
            "--malloc-trim",
            "--background-index",
            "--pch-storage=disk",
          },
        },
      },
    },
  },
}
