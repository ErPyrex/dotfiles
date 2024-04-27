return {
  {
    "mfussenegger/nvim-lint",
    config = function()
      local augroup = vim.api.nvim_create_augroup("LspLinting", { clear = true })

      require("lint").linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
      }

      local function debounce(ms, fn)
        local timer = vim.uv.new_timer()
        return function(...)
          local argv = { ... }
          timer:start(ms, 0, function()
            timer:stop()
            vim.schedule_wrap(fn)(unpack(argv))
          end)
        end
      end

      local function lint()
        require("lint").try_lint()
      end

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = augroup,
        pattern = { "*.js", "*.ts", "*.jsx", "*.tsx" },
        callback = debounce(500, lint),
      })
    end,
  },
}
