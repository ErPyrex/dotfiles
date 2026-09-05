vim.pack.add({
  "https://github.com/bennypowers/splitjoin.nvim",
})

local splitjoin = require("splitjoin")

vim.keymap.set("n", "gj", function()
  splitjoin.join()
end, { desc = "Join the object under cursor" })

vim.keymap.set("n", "g,", function()
  splitjoin.split()
end, { desc = "Split the object under cursor" })
