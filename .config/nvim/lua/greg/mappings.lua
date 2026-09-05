vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down one line" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up one line" })

vim.keymap.set("n", "<leader>d", '"_d', { desc = "Delete without yanking" })
vim.keymap.set("v", "<leader>d", '"_d', { desc = "Delete without yanking" })
vim.keymap.set("n", "x", '"_x', { desc = "Delete character without yanking" })
vim.keymap.set("v", "p", '"_dP', { desc = "Delete selected text without yanking" })

vim.keymap.set("n", "<Up>", "<Nop>")
vim.keymap.set("n", "<Down>", "<Nop>")
vim.keymap.set("n", "<Right>", ":bnext<cr>", { desc = "Go to next buffer" })
vim.keymap.set("n", "<Left>", ":bprevious<cr>", { desc = "Go to previous buffer" })

vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result centered" })

-- Move up one line, skipping wrapped lines if no count is provided
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move down one line, skipping wrapped lines if no count is provided
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increases the vertical size" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decreases the vertical size" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize -2<cr>", { desc = "Decreases the horizontal size" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize +2<cr>", { desc = "Increases the horizontal size" })

-- Native Undotree (Neovim 0.12+)
vim.keymap.set("n", "<leader>u", function()
  vim.cmd("packadd nvim.undotree")
  vim.cmd("Undotree")
end, { desc = "Open native undo interface" })
