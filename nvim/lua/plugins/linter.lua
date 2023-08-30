return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    enabled = true,
    config = function()
      local null_ls = require("null-ls")
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

      local format_on_save = function(bufnr)
        vim.lsp.buf.format({
          bufnr = bufnr,
          filter = function(client)
            return client.name == "null-ls"
          end,
        })
      end

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.eslint_d,
          -- null_ls.builtins.diagnostics.flake8,
          -- null_ls.builtins.formatting.black,
          null_ls.builtins.diagnostics.eslint_d,
          -- null_ls.builtins.code_actions.gitsigns,
          null_ls.builtins.formatting.stylua.with({
            extra_args = {
              "--indent-type",
              "Spaces",
              "--indent-width",
              "2",
            },
          }),
        },
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                format_on_save(bufnr)
              end,
            })
          end
        end,
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    enabled = false,
    config = function()
      local augroup = vim.api.nvim_create_augroup("LspLinting", { clear = true })

      require("lint").linters_by_ft = {
        javascript = { "eslint" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
      }

      -- vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
      vim.api.nvim_create_autocmd({
        "InsertLeave",
        "TextChangedI",
        "TextChangedP",
        "BufEnter",
        "BufWritePost",
      }, {
        group = augroup,
        pattern = { "*.js", "*.ts", "*.jsx", "*.tsx" },
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
  {
    "mhartington/formatter.nvim",
    enabled = false,
    config = function()
      local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })

      require("formatter").setup({
        logging = true,
        log_level = vim.log.levels.WARN,
        filetype = {
          javascript = {
            require("formatter.filetypes.javascript").eslint_d,
          },
          typescript = {
            require("formatter.filetypes.typescript").eslint_d,
          },
          javascriptreact = {
            require("formatter.filetypes.javascriptreact").eslint_d,
          },
          typescriptreact = {
            require("formatter.filetypes.typescriptreact").eslint_d,
          },
          lua = {
            require("formatter.filetypes.lua").stylua,
          },
        },
      })

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        pattern = { "*.js", "*.ts", "*.jsx", "*.tsx", "*.lua" },
        group = augroup,
        command = "FormatWrite",
      })
    end,
  },
}
