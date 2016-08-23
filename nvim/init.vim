" New and improved vundle-enabled vimrc

source ~/.vimrc_plugins

" stuff to check out
set completeopt=longest,menuone
set wildmode=list:longest
set wildignore+=*.o,*.obj,.git,*.pyc,*.pyo,*.gif,*.png,*.jpg,*.doctree
" https://github.com/mvantellingen/dotfiles/blob/master/_vimrc (line 80)

" basic usability stuff

colorscheme default

set number

set nobackup
set noswapfile

set backspace=indent,eol,start
set clipboard=unnamedplus
set mouse=a
set cursorline

syntax on

set encoding=utf-8
set ttyfast
set ruler
set wildmenu

" neovim specific stuff
if has('nvim')
    tnoremap <c-h> <C-\><C-n>
    imap <c-h> <esc>
    set hidden
endif

highlight Pmenu ctermfg=7* ctermbg=0* guibg=LightMagenta

" cool cryptography trick
" setlocal cryptmethod=blowfish2

" use a different shell from vim, so we can see if we're shelling out
set shell=/bin/zsh
nnoremap <c-d> :sh<cr>

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
let g:sparkupExecuteMapping = '<c-s>'

" leader hotkeys
let mapleader=","

map <leader>c :q<cr>
map <leader>s :w<CR>
map <leader>S :vnew<CR>:setlocal buftype=nofile<CR>
map <leader>e :tabf $MYVIMRC<CR>
map <leader>\| :set cursorcolumn!<CR>
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

" fuzzyfinder
map <leader>t :FufTaggedFile<cr>
map <leader>T :FufTag<cr>

" quickfix window (and search results) quick navigation
map <F1> :cN<CR>
map <F2> :cn<CR>

" tags
set tags=./tags;$HOME

" git fugitive tweaks!
map <leader>g<space> :Git 
map <leader>gs :Gstatus<cr>
autocmd BufReadPost fugitive://* set bufhidden=delete
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

" gitgutter (related) tweaks
set updatetime=1000

" gitk tweaks
let g:Gitv_OpenHorizontal = 1

" rainbow parens tweaks
au VimEnter *.py RainbowParenthesesToggle
au Syntax *.py RainbowParenthesesLoadRound
au Syntax *.py RainbowParenthesesLoadSquare
au Syntax *.py RainbowParenthesesLoadBraces

" jedi-vim tweaks
" let g:jedi#popup_on_dot = 0
" let g:jedi#goto_command = "<leader>d"
" let g:jedi#goto_assignments_command = "<leader>g"
" let g:jedi#goto_definitions_command = ""
" let g:jedi#documentation_command = "K"
" let g:jedi#usages_command = "<leader>n"
" let g:jedi#completions_command = "<C-Space>"
" let g:jedi#rename_command = ""

" vim-airline fu
set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

noremap ; :
nnoremap <BS> :nohlsearch<CR>:SyntasticReset<CR>

map <Tab> <C-w><C-w>
let g:netrw_winsize = ""

nnoremap <F5> :GundoToggle<CR>
let g:gundo_preview_bottom = 1
map <leader>O :1,1000bd<CR>

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


" cool trick, but let's test it on other OSes, and find a nice toggle fix for
" it
" if has("gui_running")
"   set fuoptions=maxvert,maxhorz
"   au GUIEnter * set fullscreen
" endif


function VWU()
    VimwikiDiaryIndex
    VimwikiDiaryGenerateLinks
    VimwikiAll2HTML
endfunction

" custom commands
command Sblame :%!svn blame %


" Jump to the next or previous line that has the same level or a lower
" level of indentation than the current line.
"
" exclusive (bool): true: Motion is exclusive
" false: Motion is inclusive
" fwd (bool): true: Go to next line
" false: Go to previous line
" lowerlevel (bool): true: Go to line with lower indentation level
" false: Go to line with the same indentation level
" skipblanks (bool): true: Skip blank lines
" false: Don't skip blank lines
function! NextIndent(exclusive, fwd, lowerlevel, skipblanks)
  let line = line('.')
  let column = col('.')
  let lastline = line('$')
  let indent = indent(line)
  let stepvalue = a:fwd ? 1 : -1
  while (line > 0 && line <= lastline)
    let line = line + stepvalue
    if ( ! a:lowerlevel && indent(line) == indent ||
          \ a:lowerlevel && indent(line) < indent)
      if (! a:skipblanks || strlen(getline(line)) > 0)
        if (a:exclusive)
          let line = line - stepvalue
        endif
        exe line
        exe "normal " column . "|"
        return
      endif
    endif
  endwhile
endfunction

" Moving back and forth between lines of same or lower indentation.
nnoremap <silent> [l :call NextIndent(0, 0, 0, 1)<CR>
nnoremap <silent> ]l :call NextIndent(0, 1, 0, 1)<CR>
nnoremap <silent> [L :call NextIndent(0, 0, 1, 1)<CR>
nnoremap <silent> ]L :call NextIndent(0, 1, 1, 1)<CR>
vnoremap <silent> [l <Esc>:call NextIndent(0, 0, 0, 1)<CR>m'gv''
vnoremap <silent> ]l <Esc>:call NextIndent(0, 1, 0, 1)<CR>m'gv''
vnoremap <silent> [L <Esc>:call NextIndent(0, 0, 1, 1)<CR>m'gv''
vnoremap <silent> ]L <Esc>:call NextIndent(0, 1, 1, 1)<CR>m'gv''
onoremap <silent> [l :call NextIndent(0, 0, 0, 1)<CR>
onoremap <silent> ]l :call NextIndent(0, 1, 0, 1)<CR>
onoremap <silent> [L :call NextIndent(1, 0, 1, 1)<CR>
onoremap <silent> ]L :call NextIndent(1, 1, 1, 1)<CR>

let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" testing nvim specific settings :)
tnoremap <leader>e <C-\><C-n>
" end of nvim settings

" project specific rc files sound pretty bloody awesome
set exrc
" but let's not accept unsafe commands from them
set secure
