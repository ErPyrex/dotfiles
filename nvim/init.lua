local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

local is_bootstrap = false

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
  vim.cmd([[packadd packer.nvim]])
end

require("packer").startup(function(use)
  use("wbthomason/packer.nvim")
  use("folke/tokyonight.nvim")
  use({
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    requires = {
      "nvim-lua/plenary.nvim",
    },
  })
  use({
    "nvim-telescope/telescope-fzf-native.nvim",
    run = "make",
    cond = vim.fn.executable("make") == 1,
  })
  use({
    "nvim-treesitter/nvim-treesitter",
    run = function()
      pcall(require("nvim-treesitter.install").update({ with_sync = true }))
    end,
  })
  use({
    "neovim/nvim-lspconfig",
    requires = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
  })
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
  })
  use("lewis6991/gitsigns.nvim")
  use("nvim-lualine/lualine.nvim")
  use({
    "nvim-tree/nvim-tree.lua",
    requires = {
      "nvim-tree/nvim-web-devicons",
    },
    tag = "nightly",
  })
  use({
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup()
    end,
  })
  use("windwp/nvim-ts-autotag")
  use("mg979/vim-visual-multi")
  use({
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  })
  use({
    "TimUntersberger/neogit",
    requires = {
      "nvim-lua/plenary.nvim",
    },
  })
  use({
    "sindrets/diffview.nvim",
    requires = "nvim-lua/plenary.nvim",
  })
  use("lukas-reineke/indent-blankline.nvim")
  use("karb94/neoscroll.nvim")
  use({
    "kylechui/nvim-surround",
    tag = "*",
    config = function()
      require("nvim-surround").setup()
    end,
  })

  use("folke/neodev.nvim")
  use("jose-elias-alvarez/null-ls.nvim")
  use("onsails/lspkind.nvim")
  use({
    "iamcco/markdown-preview.nvim",
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
  })

  use("folke/neodev.nvim")
  use("seandewar/bad-apple.nvim")

  if is_bootstrap then
    require("packer").sync()
  end
end)

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

require("greg")
