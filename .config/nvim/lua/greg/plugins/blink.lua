vim.pack.add({
  {
    src = "https://github.com/saghen/blink.cmp",
    version = "v0.13.0",
  },
})

local blink = require("blink-cmp")

blink.setup({
  keymap = {
    preset = "enter",
    ["<Tab>"] = {
      "snippet_forward",
      function()
        if vim.lsp.inline_completion then
          return vim.lsp.inline_completion.get()
        end
      end,
      "fallback",
    },
  },

  signature = { enabled = false },

  appearance = {
    nerd_font_variant = "mono",
  },

  completion = {
    ghost_text = { enabled = false },
    menu = {
      scrollbar = false,
      border = "rounded",
      draw = {
        treesitter = { "lsp" },
        columns = {
          { "label", "label_description", gap = 1 },
          { "kind_icon" },
        },
      },
    },
    documentation = {
      auto_show = false,
      window = { border = "rounded" },
    },
  },

  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },

  cmdline = {
    enabled = true,
    keymap = { preset = "cmdline" },
  },

  fuzzy = { implementation = "prefer_rust_with_warning" },
})
