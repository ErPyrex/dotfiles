vim.pack.add({
  "https://github.com/nvim-tree/nvim-web-devicons",
})

require("nvim-web-devicons").setup({
  override = {
    css = {
      icon = "",
      name = "Css",
      color = "#29abe1",
      cterm_color = "91",
    },
  },
})
