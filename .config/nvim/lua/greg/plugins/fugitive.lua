vim.pack.add({
  "https://github.com/tpope/vim-fugitive",
  "https://github.com/tpope/vim-rhubarb",
})

vim.keymap.set("n", "<leader>gg", "<cmd>G<cr>", { desc = "Git status" })
vim.keymap.set("n", "<leader>gc", "<cmd>G commit<cr>", { desc = "Git commit" })
vim.keymap.set("n", "<leader>gu", "<cmd>G push<cr>", { desc = "Git push" })
vim.keymap.set("n", "<leader>gp", "<cmd>G pull<cr>", { desc = "Git pull" })
vim.keymap.set("n", "<leader>gd", "<cmd>Gvdiffsplit<cr>", { desc = "Git diff" })
