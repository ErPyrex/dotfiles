return {
  {
    "stevearc/conform.nvim",
    opts = {
      -- format_on_save = {
      --   timeout_ms = 500,
      --   lsp_fallback = true,
      -- },
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { { "eslint_d", "eslint" } },
        typescript = { { "eslint_d", "eslint" } },
        javascriptreact = { { "eslint_d", "eslint" } },
        typescriptreact = { { "eslint_d", "eslint" } },
      },
    },
    config = function(_, opts)
      local conform = require("conform")

      conform.setup(opts)

      local group = vim.api.nvim_create_augroup("Conform", { clear = true })

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.js", "*.ts", "*.jsx", "*.tsx", "*.lua" },
        group = group,
        callback = function(args)
          conform.format({
            bufnr = args.buf,
          })
        end,
      })
    end,
  },
}
