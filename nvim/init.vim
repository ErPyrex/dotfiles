syntax enable

set encoding=utf-8
set nocompatible
set number

set autoindent
set shiftwidth=2
set tabstop=2

set hlsearch
set nohlsearch
set ignorecase

set nowrap
set hidden

set nobackup
set nowritebackup
set updatetime=300

set mouse=a
set numberwidth=1
set shortmess+=c

" set rnu
set clipboard=unnamedplus

set signcolumn=yes

set cmdheight=1

call plug#begin('~/.vim/plugged')
	Plug 'mg979/vim-visual-multi', {'branch': 'master'}
	Plug 'nvim-lua/plenary.nvim'
	Plug 'TimUntersberger/neogit'
	Plug 'nvim-telescope/telescope.nvim'
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'nvim-lualine/lualine.nvim'
	Plug 'christoomey/vim-tmux-navigator'

	Plug 'windwp/nvim-autopairs'
  Plug 'windwp/nvim-ts-autotag'

	Plug 'kyazdani42/nvim-web-devicons' " for file icons
	Plug 'kyazdani42/nvim-tree.lua'

	Plug 'mattn/emmet-vim'
	Plug 'tpope/vim-commentary'

	Plug 'sheerun/vim-polyglot'
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	Plug 'AndrewRadev/tagalong.vim'
	Plug 'lewis6991/gitsigns.nvim'

	" Plug 'dracula/vim', { 'as': 'dracula' }
call plug#end()

let mapleader = " "

nnoremap <leader>q :q<cr>
nnoremap <leader>w :w<cr>

nnoremap <leader>gg :Neogit<cr>
nnoremap <leader>gc :Neogit commit<cr>

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

nnoremap <C-a> ggVG 

map <leader><Tab> :NvimTreeToggle<cr>

packadd! doki-theme
colorscheme ryuko_dark

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

imap <expr><tab> emmet#expandAbbrIntelligent("\<tab>")
