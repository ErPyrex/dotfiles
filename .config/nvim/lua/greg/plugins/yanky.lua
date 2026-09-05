vim.pack.add({
  "https://github.com/gbprod/yanky.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",
})

require("yanky").setup({
  highlight = {
    timer = 150,
  },
})

vim.keymap.set("n", "<leader>p", function()
  require("telescope").extensions.yank_history.yank_history({})
end, { desc = "Open yank history" })
