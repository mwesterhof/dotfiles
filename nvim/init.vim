" New and improved vundle-enabled vimrc

cd ~/dev
source ~/.vimrc_plugins

set completeopt=preview,menuone
set wildmenu
set wildmode=full
set wildignore+=*.o,*.obj,.git,*.pyc,*.pyo,*.gif,*.png,*.jpg,*.doctree
set path+=**
" https://github.com/mvantellingen/dotfiles/blob/master/_vimrc (line 80)

" basic usability stuff
colorscheme koehler
set background=dark

set number
set nobackup
set noswapfile
set backspace=indent,eol,start
set clipboard=unnamedplus
set mouse=a
set encoding=utf-8
set ttyfast
set ruler

" neovim specific stuff
if has('nvim')
    map <c-t> :b term<cr>i
    tnoremap <c-h> <C-\><C-n>
    imap <c-h> <esc>
    set hidden
endif

highlight Pmenu ctermfg=7* ctermbg=0* guibg=LightMagenta
highlight Search cterm=NONE ctermfg=black ctermbg=LightMagenta

"disable all gui options but scroll bars
set go-=T 
set go+=lLrRbB
set go-=lLrRbB

set linebreak

" i prefer new splits to be below or right instead of top or left
set splitbelow
set splitright

" tab/indent
set expandtab
set ts=4
set sw=4
set softtabstop=4

set autoindent
set nocindent
set smartindent

set showmode
set nowrap

set diffopt=filler,vertical

" leader hotkeys
let mapleader=","

" browsers are boring
map <leader>o :e http://localhost:8000/

map <leader>c :q<cr>
map <leader>s :w<CR>
map <leader>S :vnew<CR>:setlocal buftype=nofile<CR>
map <leader>e :e $MYVIMRC<CR>
map <leader><space> :bn<cr>

map <leader>N :vs ~/notes<cr>
map <leader>m :make<cr>

map <leader><leader> @q

" quick markdown headers
map <leader>1 yypv$r=
map <leader>2 yypv$r-

" python coding shortcuts
iab ptp import ipdb; ipdb.set_trace()
map <leader>r :!python %<CR>
map <leader>{ :set filetype=htmldjango<CR>
map <leader>C mo/\v^((class)\|(def)) [^_].+<CR>`o

" scrolling
map <Up> <C-y><C-y>
map <Down> <C-e><C-e>
set scrolloff=3

vmap <leader>f :fold<CR>
map T :TlistToggle<CR>10<C-w><
map <F6> :set lines=999<CR>:set columns=999<CR>

" search
set incsearch
set hlsearch
set ignorecase
set smartcase
set nowrapscan

" global search
map // :Ack<space>
map <ESC><ESC> :ccl<cr>

if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

" quickfix window (and search results) quick navigation
map <F1> :cN<CR>
map <F2> :cn<CR>

" tags
set tags=./tags;$HOME

set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

" gitgutter (related) tweaks
set updatetime=1000

" vim-airline fu
set laststatus=2

noremap ; :
nnoremap <BS> :nohlsearch<CR>:SyntasticReset<CR>

map <Tab> <C-w><C-w>
let g:netrw_winsize = ""

map <leader>O :bufdo bd<CR>

" filetypes
autocmd BufRead,BufNew *.md set filetype=markdown

if has("unix")
    let s:uname = substitute(system("uname"), '\n', '', '')
    if s:uname == "Darwin"
        " MAC only
        let OS="osx"

        " Technically, we should put this stuff in gvimrc, but this allows us
        " to keep it all in the same file.
        if has('gui_running')
            " GUI stuff
            set gfn=Monaco:h14
            set transparency=3
        endif

        map <D-j> ddp
        map <D-k> ddkP
    else
        let OS="linux"
    endif
else
    let OS="windows"
endif


" custom commands
command Sblame :%!svn blame %

" project specific rc files sound pretty bloody awesome
set exrc
" but let's not accept unsafe commands from them
set secure
