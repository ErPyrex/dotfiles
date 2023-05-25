local sign_icons = {
  DiagnosticSignError = "",
  DiagnosticSignWarn = "",
  DiagnosticSignHint = "",
  DiagnosticSignInfo = "",
}

for name, text in pairs(sign_icons) do
  vim.fn.sign_define(name, {
    texthl = name,
    text = text,
    numhl = "",
  })
end

require("neoscroll").setup()
-- require("fidget").setup()

require("indent_blankline").setup({
  char = "┊",
  show_trailing_blankline_indent = false,
})

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

require("mini.splitjoin").setup()

require("neo-tree").setup({
  enable_git_status = false,
  window = {
    width = 30,
  },
  filesystem = {
    filtered_items = {
      hide_gitignored = false,
      hide_dotfiles = false,
    },
  },
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

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
})

require("mini.indentscope").setup({
  symbol = "┊",
})

require("greg.set")
require("greg.maps")
require("greg.theme")
require("greg.lsp")
