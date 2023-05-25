local ok, gitsigns = pcall(require, "gitsigns")

if not ok then
  return
end

local on_attach = function(bufnr)
  local gs = package.loaded.gitsigns

  local function map(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, l, r, opts)
  end

  map("n", "]c", function()
    if vim.wo.diff then
      return "]c"
    end
    vim.schedule(function()
      gs.next_hunk()
    end)
    return "<Ignore>"
  end, { expr = true })

  map("n", "[c", function()
    if vim.wo.diff then
      return "[c"
    end
    vim.schedule(function()
      gs.prev_hunk()
    end)
    return "<Ignore>"
  end, { expr = true })

  map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
  map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
  map("n", "<leader>hS", gs.stage_buffer)
  map("n", "<leader>hu", gs.undo_stage_hunk)
  map("n", "<leader>hR", gs.reset_buffer)
  map("n", "<leader>hp", gs.preview_hunk)
  map("n", "<leader>hb", function()
    gs.blame_line({ full = true })
  end)
  map("n", "<leader>tb", gs.toggle_current_line_blame)
  map("n", "<leader>hd", gs.diffthis)
  map("n", "<leader>hD", function()
    gs.diffthis("~")
  end)
  map("n", "<leader>td", gs.toggle_deleted)

  map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
end

local signs = {
  add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
  change = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
  delete = { hl = "GitSignsDelete", text = "▎", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
  topdelete = { hl = "GitSignsDelete", text = "▎", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
  changedelete = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
  untracked = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
}

gitsigns.setup({
  on_attach = on_attach,
  signs = signs,
})
