require("neoscroll").setup()

require("nvim-tree").setup({
  git = {
    ignore = false,
  },
})

require("indent_blankline").setup({
  char = "┊",
  show_trailing_blankline_indent = false,
})

require("greg.set")
require("greg.maps")
require("greg.theme")
