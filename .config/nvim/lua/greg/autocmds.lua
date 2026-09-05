vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank()
  end,
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  pattern = "*",
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = vim.api.nvim_create_augroup("ResizeSplit", { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

--[[
vim.api.nvim_create_autocmd("LspProgress", {
  callback = function()
    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    vim.notify(vim.lsp.status(), vim.log.levels.INFO, {
      id = "lsp_progress",
      title = "LSP Progress",
      opts = function(notif)
        notif.icon = spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})
]]

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "fugitive", "gitcommit", "git" },
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})
