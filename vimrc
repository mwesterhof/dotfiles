" New and improved vundle-enabled vimrc

" required for vundle:
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'


" my plugins
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'mattsacks/vim-eddie'
Plugin 'tpope/vim-fugitive'
Plugin 'bling/vim-airline'
Plugin 'kien/rainbow_parentheses.vim'

Plugin 'gundo'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required


" Non-vundle realms start here

" stuff to check out
set completeopt=longest,menuone
set wildmode=list:longest
set wildignore+=*.o,*.obj,.git,*.pyc,*.pyo,*.gif,*.png,*.jpg,*.doctree
" https://github.com/mvantellingen/dotfiles/blob/master/_vimrc (line 80)

" basic usability stuff

colorscheme eddie

set number
set go-=T 

set nobackup
set noswapfile

set clipboard=unnamed

syntax on

set encoding=utf-8
set ttyfast
set ruler
set wildmenu

highlight Pmenu ctermfg=1 ctermbg=4 guibg=grey30

"disable all gui options but scroll bars
set go+=lLrRbB
set go-=lLbB
set linebreak

" tab/indent
set expandtab
set ts=4
set sw=4
set softtabstop=4

set autoindent
set nocindent
set smartindent
set showmode

set diffopt=filler,vertical

" leader hotkeys
let mapleader=","

map <leader>c :bd<cr>
map <leader>w :w<CR>
map <leader>e :tabf $MYVIMRC<CR>
map <leader>\| :set cursorcolumn!<CR>
map <leader><space> :bn<cr>

map <leader><leader> @q

" python coding shortcuts
iab ptp import ipdb; ipdb.set_trace()
map <leader>r :!python %<CR>
map <leader>{ :set filetype=htmldjango<CR>
map <leader>C mo/^\(\(class\)\\|\(def\)\) [^_].\+<CR>`o

" scrolling
map <Up> <C-y><C-y>
map <Down> <C-e><C-e>
set scrolloff=3

vmap <leader>f :fold<CR>
map Q :NERDTreeToggle<CR>
map <F6> :set lines=999<CR>:set columns=999<CR>

" search
set incsearch
set hlsearch
set ignorecase
set smartcase
set nowrapscan


" global search hackery (// for search, <esc><esc> to close results
map // :cope<CR>:vimgrep //gj **/*<left><left><left><left><left><left><left><left>
map <ESC><ESC> :ccl<cr>

" quickfix window (and search results) quick navigation
map <F1> :cN<CR>
map <F2> :cn<CR>

" git fugitive tweaks!
map <leader>g<space> :Git 
map <leader>gs :Gstatus<cr>
autocmd BufReadPost fugitive://* set bufhidden=delete
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

" rainbow parens tweaks
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" vim-airline fu
set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

noremap ; :
nnoremap <BS> :nohlsearch<CR>:SyntasticReset<CR>

map <Tab> <C-w><C-w>

nnoremap <F5> :GundoToggle<CR>
let g:gundo_preview_bottom = 1

let NERDTreeIgnore=['\.pyc$', '\~$']

" filetypes
autocmd BufRead,BufNew *.md set filetype=markdown

" GUI stuff

" MAC only

if has("unix")
    let s:uname = substitute(system("uname"), '\n', '', '')
    if s:uname == "Darwin"
        let OS="osx"
        set gfn=Monaco:h12
        map <D-j> ddp
        map <D-k> ddkP
    else
        let OS="linux"
    endif
else
    let OS="windows"
endif
