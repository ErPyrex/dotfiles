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
" set clipboard=unnamedplus
set clipboard=unnamedplus

set signcolumn=yes

set cmdheight=1
set completeopt=menu,menuone,noselect

call plug#begin('~/.vim/plugged')
	Plug 'mg979/vim-visual-multi', {'branch': 'master'}
	Plug 'nvim-lua/plenary.nvim'
	Plug 'TimUntersberger/neogit'
	Plug 'nvim-telescope/telescope.nvim'
	" Plug 'neoclide/coc.nvim', {'branch': 'release'}
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

	" Temas
	Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
	" Plug 'dracula/vim', { 'as': 'dracula' }
	" Plug 'catppuccin/nvim', {'as': 'catppuccin'}
	
	" LSP
	Plug 'neovim/nvim-lspconfig'
	Plug 'hrsh7th/nvim-cmp'
	Plug 'hrsh7th/cmp-nvim-lsp'
	Plug 'williamboman/nvim-lsp-installer'


	" Snippets
	Plug 'L3MON4D3/LuaSnip'
	Plug 'saadparwaiz1/cmp_luasnip'
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

" packadd! doki-theme
" colorscheme ryuko_dark
" colorscheme dracula

imap <expr><tab> emmet#expandAbbrIntelligent("\<tab>")

" Ir a el buffer anterior o siguiente
nnoremap <Tab> :bnext<cr>
nnoremap <S-Tab> :bprevious<cr>

" Mover linea seleccionada hacia arriba o hacia abajo
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
