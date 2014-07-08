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

" git!
map <leader>g :!git 

noremap ; :
nnoremap <BS> :nohlsearch<CR>

map <Tab> <C-w><C-w>

nnoremap <F5> :GundoToggle<CR>
let g:gundo_preview_bottom = 1

let NERDTreeIgnore=['\.pyc$', '\~$']


" GUI stuff


" MAC only
map <D-j> ddp
map <D-k> ddkP

