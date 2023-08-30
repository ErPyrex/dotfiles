return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.1",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<C-u>"] = false,
            ["<C-d>"] = false,
          },
        },
        file_ignore_patterns = {
          "node_modules",
        },
        preview = false,
      },
    },
    config = function(_, opts)
      require("telescope").setup(opts)

      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")

      local builtin = require("telescope.builtin")

      vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
      vim.keymap.set("n", "<leader><space>", builtin.buffers, {})
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

      vim.keymap.set("n", "<leader>?", builtin.oldfiles, {})
      vim.keymap.set("n", "sw", builtin.grep_string, {})

      vim.keymap.set("n", "<leader>gf", builtin.git_files, { desc = "Search [G]it [F]iles" })
      vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
    end,
  },
}
