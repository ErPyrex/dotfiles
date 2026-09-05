vim.pack.add({
  "https://github.com/lewis6991/gitsigns.nvim",
})

require("gitsigns").setup({
  on_attach = function(bufnr)
    local gs = require("gitsigns")

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map("n", "]c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        ---@diagnostic disable-next-line: param-type-mismatch
        gs.nav_hunk("next")
      end
    end, { desc = "Next hunk" })

    map("n", "[c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        ---@diagnostic disable-next-line: param-type-mismatch
        gs.nav_hunk("prev")
      end
    end, { desc = "Previous hunk" })

    map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage current hunk" })
    map("v", "<leader>hs", function()
      gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "Stage selected lines" })

    map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset current hunk" })
    map("v", "<leader>hr", function()
      gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "Reset selected lines" })

    map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage entire buffer" })
    map("n", "<leader>hu", gs.stage_hunk, { desc = "Undo last hunk staging (Toggle)" })
    map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset entire buffer" })
    map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview current hunk" })
    map("n", "<leader>hb", function()
      gs.blame_line({ full = true })
    end, { desc = "Blame current line" })
    map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle blame for current line" })
    map("n", "<leader>hd", gs.diffthis, { desc = "Diff preview current line" })
    map("n", "<leader>hD", function()
      ---@diagnostic disable-next-line: param-type-mismatch
      gs.diffthis("~")
    end, { desc = "Diff preview current line with previous version" })
    map("n", "<leader>td", gs.preview_hunk_inline, { desc = "Preview deleted/added lines inline" })

    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select current hunk in insert or visual mode" })
  end,
})
