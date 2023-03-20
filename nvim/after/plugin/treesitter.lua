require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "cpp",
    "go",
    "lua",
    "typescript",
    "vim",
    "tsx",
    "javascript",
    "html",
    "css",
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
    disable = {
      "python",
    },
  },
  autotag = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<c-space>",
      node_incremental = "<c-space>",
      scope_incremental = "<c-s>",
      node_decremental = "<M-space>",
    },
  },
})
