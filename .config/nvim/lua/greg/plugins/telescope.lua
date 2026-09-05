vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",
  { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim", build = "make" },
})

local telescope = require("telescope")
local actions = require("telescope.actions")

local fd_command = vim.fn.executable("fdfind") == 1 and "fdfind" or "fd"

telescope.setup({
  defaults = {
    -- path_display = { "smart" },
    prompt_prefix = "   ",
    selection_caret = "  ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
      "--glob",
      "!**/.git/*",
    },
  },
  pickers = {
    find_files = {
      -- Usamos la variable detectada para el comando
      find_command = { fd_command, "--type", "f", "--strip-cwd-prefix", "--hidden", "--exclude", ".git" },
    },
  },
})

pcall(telescope.load_extension, "fzf")

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader><space>", builtin.buffers, { desc = "Switch buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Grep word" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Search diagnostics" })
