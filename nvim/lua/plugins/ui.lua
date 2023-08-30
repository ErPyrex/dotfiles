return {
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      -- enable_git_status = false,
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
    },
    keys = {
      { "<leader><tab>", "<cmd>Neotree toggle<cr>" },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      char = "┊",
      show_trailing_blankline_indent = false,
    },
  },
  {
    "echasnovski/mini.indentscope",
    opts = {
      symbol = "┊",
    },
  },
}
