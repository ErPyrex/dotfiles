vim.pack.add({
  {
    src = "https://github.com/catppuccin/nvim",
    name = "catppuccin",
  },
})

local catppuccin = require("catppuccin")

--- @diagnostic disable-next-line: missing-fields
catppuccin.setup({
  custom_highlights = function(colors)
    return {
      -- Make popup menus use the same background as the editor
      Pmenu = { bg = colors.base, fg = colors.overlay2 },
      PmenuSel = { bg = colors.surface0, style = { "bold" } },

      -- Make floating windows use the same background as the editor
      NormalFloat = { fg = colors.text, bg = colors.base },
      FloatBorder = { fg = colors.blue, bg = colors.base },
      FloatTitle = { fg = colors.subtext0, bg = colors.base },

      -- Blink cmp: these must be set explicitly because blink's winhighlight
      -- doesn't follow Pmenu/NormalFloat links reliably
      BlinkCmpMenu = { bg = colors.base },
      BlinkCmpMenuBorder = { fg = colors.blue, bg = colors.base },
      BlinkCmpDoc = { bg = colors.base },
      BlinkCmpDocBorder = { fg = colors.blue, bg = colors.base },
      BlinkCmpMenuSelection = { bg = colors.surface0, style = { "bold" } },
      BlinkCmpLabel = { fg = colors.text },
      BlinkCmpLabelMatch = { fg = colors.text },

      SnacksIndent = { fg = colors.overlay0 },
      SnacksIndentScope = { fg = colors.rosewater },
    }
  end,
})

vim.cmd.colorscheme("catppuccin")
