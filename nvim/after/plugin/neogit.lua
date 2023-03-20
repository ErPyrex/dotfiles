local neogit = require("neogit")

neogit.setup({
  integrations = {
    diffview = true,
  },
})

vim.keymap.set("n", "<leader>gg", function()
  neogit.open()
end, { noremap = true })

vim.keymap.set("n", "<leader>gc", function()
  neogit.open({ "commit" })
end, { noremap = true })
