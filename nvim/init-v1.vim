syntax enable

set encoding=utf-8
set number
set autoindent
set hlsearch
set nowrap
set shiftwidth=2
set tabstop=2

set hidden
set nobackup
set nowritebackup
" set cmdheight=2
set updatetime=300

set rnu
set mouse=a
" set clipboard+=unnamedplus
set numberwidth=1

call plug#begin('~/.vim/plugged')
	Plug 'mg979/vim-visual-multi', {'branch': 'master'}
	Plug 'nvim-lua/plenary.nvim'
	Plug 'TimUntersberger/neogit'
	Plug 'nvim-telescope/telescope.nvim'
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'nvim-lualine/lualine.nvim'
	Plug 'christoomey/vim-tmux-navigator'
	Plug 'jiangmiao/auto-pairs'

	Plug 'kyazdani42/nvim-web-devicons' " for file icons
	Plug 'kyazdani42/nvim-tree.lua'

	Plug 'dracula/vim', { 'as': 'dracula' }
	Plug 'mattn/emmet-vim'
	Plug 'tpope/vim-commentary'
call plug#end()

let mapleader = " "

nnoremap <leader>q :q<cr>
nnoremap <leader>w :w<cr>

nnoremap <leader>gg :Neogit<cr>
nnoremap <leader>gc :Neogit commit<cr>

" colorscheme dracula

imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

nnoremap <C-a> ggVG 

map <leader><Tab> :NvimTreeToggle<cr>

lua require('lualine').setup()
lua require('nvim-tree').setup()

packadd! doki-theme

" colorscheme katsuragi_misato
colorscheme rem

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"


function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

noremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" inoremap <silent><expr> <c-y> pumvisible() ? coc#_select_confirm() : "\<c-y>"
