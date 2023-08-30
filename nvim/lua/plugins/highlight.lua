return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "nvim-treesitter/playground",
  },
  build = ":TSUpdate",
  opts = {
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
    playground = {
      enable = true,
    },
    ensure_installed = {
      -- "astro",
      "bash",
      "css",
      "html",
      "javascript",
      "json",
      "lua",
      "markdown",
      "prisma",
      "regex",
      "tsx",
      "typescript",
      "vim",
      "python",
      -- "go",
      "rust",
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)

    vim.filetype.add({
      extension = {
        mdx = "markdown.mdx",
      },
      filename = {},
      pattern = {},
    })
  end,
}
