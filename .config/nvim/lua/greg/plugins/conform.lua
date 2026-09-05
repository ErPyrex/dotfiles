vim.pack.add({
  "https://github.com/stevearc/conform.nvim",
})

local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "biome", "prettierd", stop_after_first = true },
    typescript = { "biome", "prettierd", stop_after_first = true },
    javascriptreact = { "biome", "prettierd", stop_after_first = true },
    typescriptreact = { "biome", "prettierd", stop_after_first = true },
    json = { "biome" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
})
