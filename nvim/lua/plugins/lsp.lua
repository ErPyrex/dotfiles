local lsp_kind = {
  Array = "",
  Boolean = "",
  Class = "",
  Color = "",
  Constant = "",
  Constructor = "",
  Copilot = "",
  Enum = "",
  EnumMember = "",
  Event = "",
  Field = "",
  File = "",
  Folder = "",
  Function = "",
  Interface = "",
  Key = "",
  Keyword = "",
  Method = "",
  Module = "",
  Namespace = "",
  Null = "",
  Number = "",
  Object = "",
  Operator = "",
  Package = "",
  Property = "",
  Reference = "",
  Snippet = "",
  -- Snippet = "",
  String = "",
  Struct = "",
  Text = "",
  TypeParameter = "",
  Unit = "",
  Value = "",
  Variable = "",
}

---@class CmpFormatOptions
---@field maxWidth number

---@param opts CmpFormatOptions
local function cmp_format(opts)
  return function(_, item)
    if lsp_kind[item.kind] then
      item.kind = lsp_kind[item.kind]
    end

    item.menu = ""

    if #item.abbr > opts.maxWidth then
      item.abbr = item.abbr:sub(1, opts.maxWidth) .. "…"
    end

    return item
  end
end

local servers = {
  -- volar = {},
  -- astro = {},
  bashls = {},
  cssls = {},
  emmet_ls = {
    filetypes = {
      "html",
      "javascriptreact",
      "typescriptreact",
    },
  },
  -- intelephense = {},
  html = {},
  lua_ls = {},
  -- prismals = {},
  pyright = {},
  tailwindcss = {},
  tsserver = {},
  stylua = {},
  eslint_d = {},

  gopls = {},
  goimports = {},
  gofumpt = {},
}

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = {},
      },
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      {
        "folke/neodev.nvim",
        opts = {},
      },
    },
    keys = {
      { "<space>e", vim.diagnostic.open_float },
      { "<space>[d", vim.diagnostic.goto_prev },
      { "<space>]d", vim.diagnostic.goto_next },
      { "<space>q", vim.diagnostic.setloclist },
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      require("mason-tool-installer").setup({
        ensure_installed = vim.tbl_keys(servers),
      })

      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}

            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})

            lspconfig[server_name].setup(server)
          end,
        },
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-path",
      -- "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      luasnip.config.setup({})
      -- require("luasnip.loaders.from_vscode").lazy_load()

      ---@diagnostic disable: missing-fields
      cmp.setup({
        formatting = {
          format = cmp_format({
            maxWidth = 20,
          }),
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered({
            scrollbar = false,
          }),
          documentation = cmp.config.window.bordered({
            scrollbar = false,
          }),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-j>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end),
          ["<C-k>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.expand_or_jumpable(-1) then
              luasnip.expand_or_jump(-1)
            else
              fallback()
            end
          end),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
          { name = "crates" },
        },
      })
    end,
  },
}
