vim.pack.add({
  "https://github.com/laytan/cloak.nvim",
})

require("cloak").setup({
  enabled = true,
  cloak_character = "*",
  highlight_group = "Comment",
  cloak_length = nil,
  patterns = {
    {
      file_pattern = ".env*",
      cloak_pattern = "=.+",
    },
  },
})
