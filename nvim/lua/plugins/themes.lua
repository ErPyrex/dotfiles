return {
  {
    "folke/tokyonight.nvim",
    enabled = false,
    priority = 1000,
    opts = {
      style = "night",
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)

      vim.cmd.colorscheme("tokyonight")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        -- theme = "tokyonight",
        icons_enabled = false,
        -- component_separators = "│",
        component_separators = "",
        section_separators = "",
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diagnostics" },
        lualine_c = {},
        lualine_x = {},
        lualine_y = { "filename" },
        lualine_z = { "location" },
      },
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      integrations = {
        neotree = true,
        illuminate = true,
      },
    },
    init = function()
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
