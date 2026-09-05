vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Make line numbers default
vim.wo.number = true
vim.o.relativenumber = true

vim.o.splitbelow = true -- Put new windows below current
vim.o.splitright = true -- Put new windows right of current

vim.wo.wrap = false

-- Enable mouse mode
vim.o.mouse = "a"

vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true
vim.opt.swapfile = false

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

vim.o.scrolloff = 8

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
-- vim.opt.expandtab = true

-- vim.opt.cursorline = true
vim.opt.laststatus = 3

vim.opt.background = "dark"

-- Experimental Neovim 0.12+ UI redesign (ui2)
-- Provides a cleaner command line and message experience.
-- It avoids "Press ENTER" and improves the message pager.
if vim.version().minor >= 12 then
  pcall(function()
    require("vim._core.ui2").enable()
  end)
end
