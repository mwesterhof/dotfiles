" New and improved vundle-enabled vimrc
" vimscript tutorial http://learnvimscriptthehardway.stevelosh.com/chapters/18.html


cd ~/dev
source ~/.vimrc_plugins

" functions {{{

" comments
function! TogglePythonComment()
    normal 0^"ay$
    if @a[0] ==# '#'
        normal 2x
    else
        normal I# 
    endif
endfunction

function! ToggleCStyleComment()
    normal 0^"ay$
    if @a[:2] ==# '/* '
        normal 0^3x$F*hd$
    else
        normal I/* 
        normal A */
    endif
endfunction

function! ToggleHTMLComment()
    normal 0^"ay$
    if @a[:4] ==# '<!-- '
        normal 0^5x$2F-hd$
    else
        normal I<!-- 
        normal A -->
    endif
endfunction

function! ToggleHTMLDjangoComment()
    normal 0^"ay$
    if @a[:2] ==# '{# '
        normal 0^3x$F#hd$
    else
        normal I{# 
        normal A #}
    endif
endfunction

function! ToggleLatexComment()
    normal 0^"ay$
    if @a[0] ==# '%'
        normal 2x
    else
        normal I% 
    endif
endfunction

function! ToggleProjectDrawer()
    if !exists('t:drawer_enabled')
        let t:drawer_enabled = 1
        normal mQ
        e .
        vs
        normal C
        1 wincmd w
        1000 wincmd <
        30 wincmd >
        2 wincmd w
        normal `Q
        1 wincmd w
    else
        unlet t:drawer_enabled
        let g:netrw_chgwin = -1
        1 wincmd c
    endif
endfunction

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
    Terminal
    normal <c-h>
    file term
    let &cmdheight = l:cmdheight_old
    startinsert
endfunction

function! FixWindowWidth(...)
    if a:0 == 0
        if &textwidth == 0
            let l:textwidth = 119
        else
            let l:textwidth = &textwidth
        endif
    else
        let l:textwidth = a:1
    endif
    let l:desired_width = l:textwidth + 2
    normal 10000<
    execute "normal " . l:desired_width . ">"
endfunction


" 2 wrapper functions to toggle TODO items in my markdown docs
" A bit hacky and overly specific
function! ToggleStrikeTodo()
    let l:currentline = getline('.')
    if l:currentline =~ '<strike>'
        normal ma0^f wd%$d%`a
    else
        normal ma0^f wi<strike>$A</strike>`a
    endif
endfunction

function! ToggleTodo()
    let l:currentline = getline('.')
    if l:currentline =~ '\[X\]'
        normal ma0^f[lr `a
    elseif l:currentline =~ '\[ \]'
        normal ma0^f[lrX`a
    else
        normal ma0^wi[ ] 
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
        Terminal
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
        set filetype=markdown
    endif
endfunction

function! CycleNumberSetting()
    set number!

    " if !exists('b:number_toggle_value')
    "     let b:number_toggle_value = 1
    "     setlocal number
    "     setlocal norelativenumber
    " elseif b:number_toggle_value == 1
    "     let b:number_toggle_value = 2
    "     setlocal number
    "     setlocal relativenumber
    " elseif b:number_toggle_value == 2
    "     unlet b:number_toggle_value
    "     setlocal norelativenumber
    "     setlocal nonumber
    " endif
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

function! FixHighlights()
    " some limelight-based settings
    let g:limelight_conceal_ctermfg = 'gray'
    let g:limelight_conceal_ctermfg = 240
    " Color name (:help gui-colors) or RGB color
    let g:limelight_conceal_guifg = 'DarkGray'
    let g:limelight_conceal_guifg = '#777777'
    " Number of preceding/following paragraphs to include (default: 0)
    let g:limelight_paragraph_span = 1

    " mute the end-of-file tildes
    highlight EndOfBuffer ctermfg=black guifg=black

    " make search menus less fugly
    highlight Pmenu ctermfg=7* ctermbg=0* guibg=LightMagenta
    highlight Search cterm=NONE ctermfg=red ctermbg=black

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

    " disable opaque background
    highlight Normal ctermbg=none
endfunction

function! MapSpaceWindowSwitchers()
    " is run once on startup
    let l:i = 1
    while l:i <= 9
        execute 'nnoremap <silent> <space>' . l:i . ' :' . l:i . 'wincmd w<cr>'
        let l:i += 1
    endwhile
endfunction

function! MapSpaceSpaceTabSwitchers()
    " is run once on startup
    let l:i = 1
    while l:i <= 9
        execute 'nnoremap <silent> <space><space>' . l:i . ' :' . l:i . 'tabn<cr>'
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

vnoremap / y:Ack <c-r>+ --python
nnoremap ? yiw:Ack <c-r>+ --python
nnoremap // :Ack<space>
nnoremap <ESC><ESC> :ccl<cr>

if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

nnoremap <F2> :cN<CR>
nnoremap <F3> :cn<CR>

set tags=./tags;$HOME
" }}}


" basic essentials {{{
set nobackup
set noswapfile
set backspace=indent,eol,start
set clipboard=unnamedplus
set mouse=a
set encoding=utf-8
set ruler

set expandtab
set ts=4
set sw=4
set softtabstop=4
set textwidth=119
set formatoptions-=t

set autoindent
set nocindent
set smartindent
set wildignorecase " allows case insensitive tab complete for :b command. why this isn't turned on by default, i don't know

set showmode
set nowrap

set diffopt=filler,vertical
" }}}


" pretties {{{
" colorscheme gruvbox
colorscheme apprentice
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

" don't close buffers automatically
set hidden

" makes :sb switch to window if buffer is already open there
" for now, also switch to tab, see how that goes
set switchbuf=useopen,usetab
" }}}


" neovim specific stuff {{{
if has('nvim')
    nnoremap <c-t> :call FancyOpenTerm()<cr>
    tnoremap <c-h> <C-\><C-n>
    set inccommand=nosplit

    " temporary workaround to fix weird characters in MATE+neovim
    set guicursor=
else
    set ttyfast  " removed in neovim
endif
" }}}


" custom mappings {{{
" the only way to exit insert mode is to use CTRL-h
" this way, usage of editor and nvim term will be more consistent
inoremap <esc> <nop>
inoremap <c-c> <nop>
inoremap <c-h> <esc>

let mapleader=","

" o -> open that url in the browser
" O -> open some (probably localhost) url in editor (source)
nnoremap <leader>o :!python -m webbrowser -t http://localhost:8000/
nnoremap <leader>O :e http://localhost:8000/

nnoremap <silent> <leader>c :q<cr>
nnoremap <leader>s :w<CR>
nnoremap <silent> <c-s> :call FancyOpenScratch()<cr>
nnoremap <silent> <leader>e :e .<CR>
nnoremap <silent> <leader>E :e $MYVIMRC<CR>
" nnoremap <silent> <leader><space> :bn<cr>

nnoremap <silent> <leader>n :call CycleNumberSetting()<cr>

nnoremap <silent> <leader>N :vs ~/Documents/notes/docs<cr>
nnoremap <silent> <leader>T :vs ~/todo.md<cr>
nnoremap <silent> <leader>m :make<cr>

nnoremap <leader><leader> @q
inoremap <leader><leader> <esc>
vnoremap <silent> <leader>f :fold<CR>
" perform :find, open result in new vertical window
nnoremap <silent> <leader>f :vertical sfind
" open file under cursor in new vertical window
nnoremap <silent> <leader>F :Fm<cr>
nnoremap <silent> T :TagbarToggle<CR>
nnoremap <silent> <leader>G :FloatIt<CR>

nnoremap ; :
nnoremap <silent> <BS> :nohlsearch<CR>
nnoremap <Tab> <C-w><C-w>
nnoremap <c-w>f :call FixWindowWidth()<cr>
nnoremap <leader>l :LineHint<space>

" just in case we might want to use a project drawer
nnoremap <silent> Q :call ToggleProjectDrawer()<cr>

" clever way to kick off custom commands using trigger file mapped using entr
nnoremap <silent> <leader><CR> :call jobstart('touch ~/.trigger')<CR>

" toggle todo items in markdown
autocmd FileType markdown :nnoremap <buffer> <leader>t :call ToggleTodo()<cr>
" autocmd FileType markdown :nnoremap <buffer> <leader>t :call ToggleStrikeTodo()<cr>

" map <space>1-9 to window positions <3
call MapSpaceWindowSwitchers()
call MapSpaceSpaceTabSwitchers()
" }}}


" python coding shortcuts {{{
augroup python
autocmd!
autocmd FileType python :iab <buffer> ptp import ipdb; ipdb.set_trace()
autocmd FileType python :nnoremap <buffer> <leader>r :!python3 %<CR>
autocmd FileType python :nnoremap <buffer> <leader>C mo/\v^((class)\|(def)) [^_].+<CR>`o
autocmd FileType python :nnoremap <buffer> <leader>/ :call TogglePythonComment()<CR>
augroup END
" }}}


" golang coding shortcuts {{{
augroup golang
autocmd!
autocmd FileType go :nnoremap <buffer> <leader>r :!/usr/local/go/bin/go run %<CR>
augroup END
" }}}


" html shortcuts {{{
augroup html
autocmd!
autocmd FileType html :nnoremap <buffer> <leader>{ :set filetype=htmldjango<CR>
autocmd FileType html :nnoremap <buffer> <leader>/ :call ToggleHTMLComment()<CR>
augroup END
" }}}


" htmldjango shortcuts {{{
augroup htmldjango
autocmd!
autocmd FileType htmldjango :nnoremap <buffer> <leader>{ :set filetype=html<CR>
autocmd FileType htmldjango :nnoremap <buffer> <leader>/ :call ToggleHTMLDjangoComment()<CR>
augroup END
" }}}


" c shortcuts {{{
augroup cshortcuts
autocmd!
autocmd FileType c :nnoremap <buffer> <leader>/ :call ToggleCStyleComment()<CR>
augroup END
" }}}


" tex shortcuts {{{
augroup texshortcuts
autocmd!
autocmd FileType c :nnoremap <buffer> <leader>/ :call ToggleCStyleComment()<CR>
autocmd FileType tex :nnoremap <buffer> <leader>/ :call ToggleLatexComment()<CR>
let g:tex_flavor = "latex"
augroup END
" }}}

" markdown shortcuts {{{
augroup markdownshortcuts
autocmd!
autocmd FileType markdown :nnoremap <buffer> <leader>1 yypv$r=
autocmd FileType markdown :nnoremap <buffer> <leader>2 yypv$r-
augroup END
" }}}


" scrolling {{{
nnoremap <Up> 4<C-y>
nnoremap <Down> 4<C-e>
" set scrolloff=3
" }}}


" plugin tweaks {{{
" limelight/goyo
"autocmd User GoyoEnter Limelight
"autocmd User GoyoLeave Limelight!
autocmd User GoyoLeave call FixHighlights()
let g:goyo_width=120

" gitgutter
set updatetime=1000
let g:netrw_winsize = ""

" vim-airline
set laststatus=2
let g:airline_theme='badwolf'

let g:textbeat_path = '~/src/textbeat/txbt'

" fix ctrl-space's hotkey (derp)
" nnoremap <c-space> :CtrlSpace<cr>
nnoremap <leader><space> :CtrlSpace<cr>

" Mundo
nnoremap <F5> :MundoToggle<cr>

" easy motion
nmap F <Plug>(easymotion-prefix)


" Golden ratio
" nnoremap <leader>g :GoldenRatioToggle<cr>

" make snippets from dotfiles dir available to snipmate
set runtimepath+=$HOME/src/dotfiles/vim/runtime
" set some aliases
let g:snipMate = {}
let g:snipMate.snippet_version = 0
let g:snipMate.scope_aliases = {}
let g:snipMate.scope_aliases['htmldjango'] = 'html,htmldjango'
let g:snipMate.scope_aliases['python'] = 'python,django'

" use markdown compatible table corners
let g:table_mode_corner="|"

" syntastic
" let g:syntastic_python_pyflakes_exe = 'python3 -m pyflakes'
" let g:syntastic_python_python_exec = '/usr/bin/python3'

" git-messenger
map <leader>b <Plug>(git-messenger)

" }}}


" other {{{
autocmd BufRead,BufNew *.md setlocal filetype=markdown

augroup vim
autocmd!
autocmd FileType vim :setlocal foldmethod=marker
autocmd FileType vim :nnoremap <leader>r :source %<cr>
augroup END

" augroup markdown
"     autocmd!
"     autocmd FileType markdown :TableModeToggle
" augroup END

if has("unix")
    let s:uname = substitute(system("uname"), '\n', '', '')
    if s:uname == "Darwin"
        let OS="osx"
        let g:python3_host_prog = '/Users/m.westerhof/.pyenv/shims/python3'
    else
        let OS="linux"
    endif
else
    let OS="windows"
endif


" custom commands
command! Sblame :%!svn blame %
command! Go :call GoGoGadgetDeveloper()
command! Snippets :vsplit ~/src/dotfiles/vim/runtime/snippets/
command! GetDate :r!date "+\%F (\%A)"
command! Terminal :terminal


" project specific rc files sound pretty bloody awesome
set exrc
" but let's not accept unsafe commands from them
set secure
" }}}
