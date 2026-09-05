vim.pack.add({
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/nvim-tree/nvim-web-devicons",
})

local fzf = require("fzf-lua")

fzf.setup({
  winopts = {
    backdrop = 100,
  },
  fzf_opts = {
    ["--pointer"] = " ",
  },
})
