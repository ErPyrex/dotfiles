vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-neo-tree/neo-tree.nvim",
})

require("neo-tree").setup({
  log_level = "info",
  window = {
    width = 30,
  },
  filesystem = {
    filtered_items = {
      hide_gitignored = false,
      hide_dotfiles = false,
    },
  },
  default_component_configs = {
    name = {
      -- use_git_status_colors = false,
    },
    modified = {
      symbol = "",
    },
    diagnostics = {
      symbols = {
        error = "",
        warn = "",
        hint = "󰌵",
        info = " ",
      },
    },
    git_status = {
      symbols = {
        added = "",
        modified = "",
        deleted = "",
        renamed = "",
        untracked = "",
        ignored = "◌",
        unstaged = "",
        staged = "S",
        conflict = "",
      },
    },
  },
})

vim.keymap.set("n", "<leader><tab>", "<cmd>Neotree toggle<cr>", { desc = "Open Neotree" })

vim.keymap.set("n", "<leader>ge", function()
  require("neo-tree.command").execute({ source = "git_status", toggle = true })
end, { desc = "Git Explorer" })
