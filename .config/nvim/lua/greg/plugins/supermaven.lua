vim.pack.add({
  "https://github.com/supermaven-inc/supermaven-nvim",
})

local supermaven = require("supermaven-nvim")

supermaven.setup({
  ignore_filetypes = {
    ["neo-tree-popup"] = true,
    ["TelescopePrompt"] = true,
    ["DressingInput"] = true,
    ["oil"] = true,
  },
})
