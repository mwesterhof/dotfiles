" New and improved vundle-enabled vimrc
" check out https://github.com/mvantellingen/dotfiles/blob/master/_vimrc (line 80)

cd ~/dev
source ~/.vimrc_plugins

" search and completion {{{
set completeopt=preview,menuone
set wildmenu
set wildmode=full
set wildignore+=*.o,*.obj,.git,*.pyc,*.pyo,*.gif,*.png,*.jpg,*.doctree
set path+=**

set incsearch
set hlsearch
set ignorecase
set smartcase
set nowrapscan

nnoremap // :Ack<space>
nnoremap <ESC><ESC> :ccl<cr>

if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

nnoremap <F1> :cN<CR>
nnoremap <F2> :cn<CR>

set tags=./tags;$HOME
" }}}


" basic essentials {{{
set nobackup
set noswapfile
set backspace=indent,eol,start
set clipboard=unnamedplus
set mouse=a
set encoding=utf-8
set ttyfast
set ruler

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
" }}}


" pretties {{{
colorscheme evening
" mute the end-of-file tildes
hi NonText guifg=bg

highlight Pmenu ctermfg=7* ctermbg=0* guibg=LightMagenta
highlight Search cterm=NONE ctermfg=black ctermbg=LightMagenta
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

" vim-airline fu
set laststatus=2

"disable all gui options but scroll bars
set go-=T 
set go+=lLrRbB
set go-=lLrRbB
" }}}


" usability tweaks {{{
set splitbelow
set splitright
set linebreak
" }}}


" neovim specific stuff {{{
if has('nvim')
    nnoremap <c-t> :b term<cr>i
    tnoremap <c-h> <C-\><C-n>
    inoremap <c-h> <esc>
    set hidden
endif
" }}}


" custom mappings {{{
let mapleader=","
nnoremap <leader>o :e http://localhost:8000/

nnoremap <leader>c :q<cr>
nnoremap <leader>s :w<CR>
nnoremap <leader>S :vnew<CR>:setlocal buftype=nofile<CR>
nnoremap <leader>e :e $MYVIMRC<CR>
nnoremap <leader><space> :bn<cr>

nnoremap <leader>n :setlocal number!<cr>
nnoremap <leader>N :vs ~/notes<cr>
nnoremap <leader>m :make<cr>

nnoremap <leader><leader> @q
vnoremap <leader>f :fold<CR>
nnoremap <leader>f :vert sfind 
nnoremap T :TlistToggle<CR>10<C-w><

nnoremap ; :
nnoremap <BS> :nohlsearch<CR>:SyntasticReset<CR>
nnoremap <Tab> <C-w><C-w>

" quick markdown headers
autocmd FileType markdown :nnoremap <buffer> <leader>1 yypv$r=
autocmd FileType markdown :nnoremap <buffer> <leader>2 yypv$r-
" }}}


" python coding shortcuts {{{
augroup python
autocmd!
autocmd FileType python :iab <buffer> ptp import ipdb; ipdb.set_trace()
autocmd FileType python :nnoremap <buffer> <leader>r :!python %<CR>
autocmd FileType html :nnoremap <buffer> <leader>{ :set filetype=htmldjango<CR>
autocmd FileType python :nnoremap <buffer> <leader>C mo/\v^((class)\|(def)) [^_].+<CR>`o
augroup END
" }}}


" scrolling {{{
nnoremap <Up> <C-y><C-y>
nnoremap <Down> <C-e><C-e>
set scrolloff=3
" }}}


" plugin tweaks {{{
" gitgutter (related) tweaks
set updatetime=1000
let g:netrw_winsize = ""
" }}}


" other {{{
autocmd BufRead,BufNew *.md setlocal filetype=markdown
autocmd FileType vim :setlocal foldmethod=marker

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

        nnoremap <D-j> ddp
        nnoremap <D-k> ddkP
    else
        let OS="linux"
    endif
else
    let OS="windows"
endif

" custom commands
command Sblame :%!svn blame %
command Fs :!wmctrl -r ":ACTIVE:" -b toggle,fullscreen

" project specific rc files sound pretty bloody awesome
set exrc
" but let's not accept unsafe commands from them
set secure
" }}}
