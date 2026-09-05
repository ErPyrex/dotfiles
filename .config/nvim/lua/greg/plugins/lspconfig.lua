vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/folke/lazydev.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
  "https://github.com/saghen/blink.cmp",
})

local lazydev = require("lazydev")
local mason = require("mason")
local mason_tool_installer = require("mason-tool-installer")

lazydev.setup({
  library = {
    { path = "luvit-meta/library", words = { "vim%.uv" } },
  },
})

mason.setup({
  ui = { border = "rounded", width = 0.8, height = 0.8 },
})

local servers = {
  "lua_ls",
  "jsonls",
  "html",
  "emmet_language_server",
  "cssls",
  "ts_ls",
  "bashls",
  "tailwindcss",
  "biome",
  "stylua",
}

mason_tool_installer.setup({
  ensure_installed = servers,
})

vim.lsp.enable(servers)

vim.diagnostic.config({
  virtual_lines = false,
  virtual_text = false,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "if_many",
    max_width = 80,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = "󰌵 ",
    },
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(e)
    local client = vim.lsp.get_client_by_id(e.data.client_id)
    if not client then
      return
    end

    local function map(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = e.buf, desc = "LSP: " .. desc })
    end

    if client.server_capabilities.inlineCompletionProvider then
      vim.lsp.completion.enable(true, client.id, e.buf, { autostart = true })
    end

    map("n", "gd", "<cmd>Telescope lsp_definitions<cr>", "Go to definition")
    map("n", "gi", "<cmd>Telescope lsp_implementations<cr>", "Go to implementations")
    map("n", "grr", "<cmd>Telescope lsp_references<cr>", "Show references")
    map("n", "grt", "<cmd>Telescope lsp_type_definitions<cr>", "Go to type definition")

    map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")

    map({ "n", "i" }, "<C-k>", function()
      vim.lsp.buf.signature_help({ border = "rounded" })
    end, "Signature help")

    map("n", "<space>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
    map("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")

    map("n", "<leader>cf", function()
      vim.lsp.buf.format({ async = true })
    end, "Format document")
  end,
})

vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { desc = "Floating diagnostic" })
