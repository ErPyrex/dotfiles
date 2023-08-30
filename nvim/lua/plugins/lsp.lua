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

local function cmp_format()
  return function(_, item)
    if lsp_kind[item.kind] then
      item.kind = lsp_kind[item.kind]
    end

    return item
  end
end

local servers = {
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
  html = {},
  lua_ls = {},
  prismals = {},
  pyright = {},
  tailwindcss = {},
  tsserver = {},
  rust_analyzer = {
    cmd = { "rustup", "run", "stable", "rust-analyzer" },
  },
}

return {
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      {
        "williamboman/mason.nvim",
        opts = {},
      },
    },
    opts = {
      ensure_installed = vim.tbl_keys(servers),
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "folke/neodev.nvim",
    },
    config = function()
      require("neodev").setup()

      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
      vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

      local lsp_flags = {
        debounce_text_change = 150,
      }

      for server_name, settings in pairs(servers) do
        lspconfig[server_name].setup({
          flags = lsp_flags,
          capabilities = capabilities,
          settings = settings,
          filetypes = (settings or {}).filetypes,
        })
      end
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      luasnip.config.setup({})

      cmp.setup({
        formatting = {
          format = cmp_format(),
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
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },
}
