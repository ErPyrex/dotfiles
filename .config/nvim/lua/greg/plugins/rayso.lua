vim.pack.add({
  "https://github.com/TobinPalmer/rayso.nvim",
})

require("rayso").setup({
  open_cmd = "firefox",
  options = {
    background = true,
    dark_mode = true,
    padding = 32,
    theme = "tailwind",
  },
})
