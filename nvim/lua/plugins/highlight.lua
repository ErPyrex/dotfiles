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
      "vue",
      "astro",
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
      "jsdoc",
      "php",
      "ron",
      "rust",
      "toml",

      "go",
      "gomod",
      "gosum",
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
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
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
