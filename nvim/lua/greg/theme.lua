require("lualine").setup({
  options = {
    theme = "tokyonight",
  },
})

require("tokyonight").setup({
  style = "night",
})

vim.cmd([[colorscheme tokyonight]])
