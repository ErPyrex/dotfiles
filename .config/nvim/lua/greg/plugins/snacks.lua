vim.pack.add({
  "https://github.com/folke/snacks.nvim",
})

local snacks = require("snacks")

snacks.setup({
  input = {},
  select = {},
  notifier = {},
  picker = {
    sources = {
      explorer = {
        follow_file = true,
        hidden = true,
        ignored = true,
        layout = {
          layout = {
            position = "left",
            width = 30,
          },
        },
      },
    },
  },
  explorer = {},
  terminal = {},
  indent = {
    enable = true,
    indent = {
      char = "┊",
    },
    scope = {
      enable = true,
      char = "┊",
    },
  },
  statuscolumn = {},
})

vim.keymap.set("n", "<leader><tab>", function()
  snacks.explorer()
end, { desc = "Open Snacks Explorer" })

vim.keymap.set("n", "<leader>ge", function()
  snacks.picker.git_status()
end, { desc = "Git Explorer (Snacks)" })
