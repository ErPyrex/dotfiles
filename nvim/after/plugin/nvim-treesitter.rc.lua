local treesitter = require('nvim-treesitter.configs')

treesitter.setup({
  autotag = {
    enable = true,
  },
  highlight = {
		enable = true
	},
  ensure_installed = {
    -- 'astro',
    'tsx',
    'javascript',
    'json',
    'html',
    'css'
  }
})
