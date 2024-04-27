return {
  {
    "rust-lang/rust.vim",
    ft = { "rust" },
    init = function()
      vim.g.rustfmt_autosave = 1
    end,
  },
  {
    "saecki/crates.nvim",
    ft = { "rust", "toml" },
    tag = "stable",
    config = function()
      require("crates").setup()
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
    init = function()
      local run_rust = vim.api.nvim_create_augroup("run_rust", {})

      vim.api.nvim_create_autocmd("FileType", {
        group = run_rust,
        pattern = "rust",
        callback = function(e)
          vim.keymap.set("n", "<leader>rr", function()
            vim.cmd.RustLsp("runnables")
          end, {
            buffer = e.buf,
          })
        end,
      })
    end,
  },
}
