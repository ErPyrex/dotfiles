vim.pack.add({
  "https://github.com/stevearc/oil.nvim",
})

require("oil").setup({
  default_file_explorer = true,
  columns = {
    "icon",
  },
  buf_options = {
    buflisted = false,
    bufhidden = "hide",
  },
  win_options = {
    wrap = false,
    signcolumn = "no",
    cursorcolumn = false,
    foldcolumn = "0",
    spell = false,
    list = false,
    concealcursor = "nvic",
    conceallevel = 3,
  },
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true,
  view_options = {
    show_hidden = true,
    is_hidden_file = function()
      return false
    end,
    is_always_hidden_file = function()
      return false
    end,
  },
  float = {
    padding = 2,
    max_width = 0,
    max_height = 0,
    border = "rounded",
    win_options = {
      winblend = 0,
    },
  },
})

vim.keymap.set("n", "-", "<cmd>Oil --float<cr>", { desc = "Open parent directory in Oil" })
