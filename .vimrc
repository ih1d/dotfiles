syntax on filetype plugin indent on
set relativenumber
set showmode
set nowrap
set tw=80
set smartcase
set smarttab
set smartindent
set autoindent
set autoread
set backspace=indent,eol,start
set softtabstop=4
set shiftwidth=4
set expandtab
set incsearch
set history=1000
set clipboard=unnamed,autoselect
set noswapfile
highlight Comment ctermfg=green
set ruler
set ai
set completeopt=menuone,menu,longest

let &t_ut=''
set t_RV=
set encoding=UTF-8

set wildignore+=*\\tmp\\*,*.swp,*.swo,*.zip,.git,.cabal-sandbox

set wildmode=longest,list,full
set wildmenu
set completeopt+=longest

set cmdheight=1
set mouse=nicr
set splitbelow splitright

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'
Plug 'preservim/tagbar'
Plug 'kovisoft/slimv'
Plug 'lervag/vimtex'
Plug 'ryanoasis/vim-devicons'
Plug 'morhetz/gruvbox'

call plug#end()

" Customization
set background=dark
colorscheme gruvbox
let g:airline_powerline_fonts = 1

let mapleader = " "

" ********************
" **** KEY REMAPS **** 
" ********************

" INSERT 
:imap jj <Esc>

" NORMAL 
nnoremap <Leader>wj <C-W><C-J>
nnoremap <Leader>wk <C-W><C-K>
nnoremap <Leader>wh <C-W><C-H>
nnoremap <Leader>wl <C-W><C-L>
nnoremap <Leader>. :Explore<CR>
nnoremap <Leader><Tab> :bn<CR>
nnoremap <Leader><Backspace> :bp<CR>
nnoremap <Leader>wd :bd<CR>
nnoremap <Leader>d <Plug>(coc-definition)
nnoremap <Leader>t <Plug>(coc-type-definition)
nnoremap <Leader>p <Plug>(coc-diagnostic-prev)
nnoremap <Leader>n <Plug>(coc-diagnostic-next)
nnoremap <Leader>s :call ShowDoc()<CR>

noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" DISABLED
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>


let g:tex_flavor = 'latex'

" with a generic interface:
let g:vimtex_general_view_method = '/System/Applications/Preview.app/Contents/MacOS/Preview'
let g:vimtex_general_options = ''

" Use latexmk for continuous compilation
let g:vimtex_compiler_method = 'latexmk'

" Automatically open Quickfix window if errors occur
let g:vimtex_quickfix_mode = 1

" *************** 
" *** Plugins ***
" *************** 

" CoC
autocmd BufWritePost *.hs call CocActionAsync('format')
function! ShowDoc()
    if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
    else
        call feedkeys('s', 'in')
    endif
endfunction

" Tagbar
nnoremap <Leader>tt :TagbarToggle<CR>
nnoremap gj :TagbarJump<CR>
nnoremap gn :TagbarJumpNext<CR>
let g:tagbar_map_showproto = 'p'
let g:tagbar_map_close = '<space>wd'
let g:tagbar_autofocus = 1
let g:tagbar_show_data_type = 1

" Fugitive
nnoremap <Leader>ga :Git add<CR>
nnoremap <Leader>gc :Git commit<CR>
nnoremap <Leader>gp :Git pull origin main<CR>
nnoremap <Leader>gs :Git status<CR>
