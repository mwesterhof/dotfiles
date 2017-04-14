" New and improved vundle-enabled vimrc
" check out https://github.com/mvantellingen/dotfiles/blob/master/_vimrc (line 80)
" vimscript tutorial http://learnvimscriptthehardway.stevelosh.com/chapters/18.html

cd ~/dev
source ~/.vimrc_plugins


" functions {{{

" Quick dev environment reset
function! GoGoGadgetDeveloper()
    " cmdheight hack to silence prompt
    " will reset at the end
    let l:cmdheight_old = &cmdheight
    set cmdheight=3
    only
    bufdo bwipeout!
    edit .
    vsplit
    terminal
    normal <c-h>
    file term
    let &cmdheight = l:cmdheight_old
    startinsert
endfunction

" 2 wrapper functions to toggle TODO items in my markdown docs
" A bit hacky and overly specific
function! ToggleStrikeTodo()
    let l:currentline = getline('.')
    if l:currentline =~ '<strike>'
        normal 0^wd%$d%
    else
        normal 0^wi<strike>$A</strike>
    endif
endfunction

function! FancyOpenTerm()
    let l:name=input("name of terminal to create or switch to (term): ")
    if l:name==''
        let l:name="term"
    endif
    if bufexists(l:name)
        execute "buffer " . l:name
    else
        terminal
        execute "file " . l:name
    endif
endfunction

function! FancyOpenScratch()
    " opens scratch buffer, much the same way FancyOpenTerm works
    " named buffers are happy buffers
    let l:name=input("name of scratch buffer to create or switch to (scratch): ")
    if l:name==''
        let l:name="scratch"
    endif
    if bufexists(l:name)
        execute "buffer " . l:name
    else
        enew
        setlocal buftype=nofile
        execute "file " . l:name
    endif
endfunction

function! CycleNumberSetting()
    if !exists('b:number_toggle_value')
        let b:number_toggle_value = 1
        setlocal number
        setlocal norelativenumber
    elseif b:number_toggle_value == 1
        let b:number_toggle_value = 2
        setlocal number
        setlocal relativenumber
    elseif b:number_toggle_value == 2
        unlet b:number_toggle_value
        setlocal norelativenumber
        setlocal nonumber
    endif
endfunction

function! ToggleHardMode()
    if !exists('g:hardmode_enabled')
        echo "enabling hard mode (no hjkl)"
        nnoremap h <nop>
        nnoremap j <nop>
        nnoremap k <nop>
        nnoremap l <nop>
        let g:hardmode_enabled = 1
    else
        echo "disabling hard mode"
        nunmap h
        nunmap j
        nunmap k
        nunmap l
        unlet g:hardmode_enabled
    endif
endfunction

function! NightMode()
    colorscheme koehler
    call FixHighlights()
endfunction

function! DayMode()
    colorscheme evening
    call FixHighlights()
endfunction

function! FixHighlights()
    " mute the end-of-file tildes
    highlight NonText guifg=bg

    " make search menus less fugly
    highlight Pmenu ctermfg=7* ctermbg=0* guibg=LightMagenta
    highlight Search cterm=NONE ctermfg=black ctermbg=LightMagenta

    " same for c-space
    hi CtrlSpaceNormal guifg=#009900 guibg=NONE gui=bold ctermfg=9 ctermbg=NONE term=italic cterm=bold
    hi CtrlSpaceSelected guifg=#66ff66 guibg=NONE gui=italic ctermfg=9 ctermbg=NONE term=bold cterm=bold

    " Tab bar stuff
    " line
    hi TabLineFill ctermbg=DarkGrey

    " selected (text, background)
    hi TabLineSel ctermfg=DarkGreen ctermbg=Black

    " other (text, background)
    hi TabLine ctermfg=Black ctermbg=LightGrey

endfunction

function! MapSpaceWindowSwitchers()
    " is run once on startup
    let l:i = 1
    while l:i <= 9
        execute 'nnoremap <silent> <space>' . l:i . ' :' . l:i . 'wincmd w<cr>'
        let l:i += 1
    endwhile
endfunction
" }}}


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
colorscheme koehler
call FixHighlights()

set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

"disable all gui options but scroll bars
set go-=T 
set go+=lLrRbB
set go-=lLrRbB
" }}}


" usability tweaks {{{
set splitbelow
set splitright
set linebreak

" makes :sb switch to window if buffer is already open there
" for now, also switch to tab, see how that goes
set switchbuf=useopen,usetab
" }}}


" neovim specific stuff {{{
if has('nvim')
    nnoremap <c-t> :call FancyOpenTerm()<cr>
    tnoremap <c-h> <C-\><C-n>
    set hidden
endif
" }}}


" custom mappings {{{
" the only way to exit insert mode is to use CTRL-h
" this way, usage of editor and nvim term will be more consistent
inoremap <esc> <nop>
inoremap <c-c> <nop>
inoremap <c-h> <esc>

let mapleader=","
nnoremap <leader>o :e http://localhost:8000/

nnoremap <silent> <leader>c :q<cr>
nnoremap <leader>s :w<CR>
nnoremap <silent> <c-s> :call FancyOpenScratch()<cr>
nnoremap <silent> <leader>e :e .<CR>
nnoremap <silent> <leader>E :e $MYVIMRC<CR>
nnoremap <silent> <leader><space> :bn<cr>

nnoremap <silent> <leader>n :call CycleNumberSetting()<cr>

nnoremap <silent> <leader>N :vs ~/Documents/notes/docs<cr>
nnoremap <silent> <leader>m :make<cr>

nnoremap <leader><leader> @q
vnoremap <silent> <leader>f :fold<CR>
" perform :find, open result in new vertical window
nnoremap <silent> <leader>f :vertical sfind
" open file under cursor in new vertical window
nnoremap <silent> <leader>F :vertical wincmd f<cr>
nnoremap <silent> T :TagbarToggle<CR>
nnoremap <silent> <leader>gs :Gstatus<CR>

nnoremap ; :
nnoremap <silent> <BS> :nohlsearch<CR>:SyntasticReset<CR>
nnoremap <Tab> <C-w><C-w>
nnoremap <silent> <F6> :Fs<cr><cr>

" quick markdown headers
autocmd FileType markdown :nnoremap <buffer> <leader>1 yypv$r=
autocmd FileType markdown :nnoremap <buffer> <leader>2 yypv$r-

" toggle todo items in markdown (html strikeout)
autocmd FileType markdown :nnoremap <buffer> <leader>t :call ToggleStrikeTodo()<cr>

" map <space>1-9 to window positions <3
call MapSpaceWindowSwitchers()
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
nnoremap <Up> 4<C-y>
nnoremap <Down> 4<C-e>
set scrolloff=3
" }}}


" plugin tweaks {{{

" gitgutter
set updatetime=1000
let g:netrw_winsize = ""

" vim-airline
set laststatus=2

" fix ctrl-space's hotkey (derp)
nnoremap <c-space> :CtrlSpace<cr>
nnoremap <F5> :MundoToggle<cr>
" }}}


" other {{{
autocmd BufRead,BufNew *.md setlocal filetype=markdown

augroup vim
autocmd!
autocmd FileType vim :setlocal foldmethod=marker
autocmd FileType vim :nnoremap <leader>r :source %<cr>
augroup END

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
command! Sblame :%!svn blame %
command! Fs :!wmctrl -r ":ACTIVE:" -b toggle,fullscreen
command! Go :call GoGoGadgetDeveloper()

" project specific rc files sound pretty bloody awesome
set exrc
" but let's not accept unsafe commands from them
set secure
" }}}
