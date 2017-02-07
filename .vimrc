

set nocompatible
set t_Co=256

colorscheme default

syntax on
"
"
"

" todo there is some problem with typing tilde character in vim  ~~,
" sometimes it doesnt work

:set smartindent
:set incsearch

:set nocursorline


set hlsearch

set tabstop=4
set shiftwidth=4

" or smartindent
set autoindent

set number

" ignore case
set ic

" inner sentence, not sure what it does
set is

" for braces
set showmatch

" fix for stupid bug: .vimrc scped to mac would have ^M at end of lines, because of editing on windows machine
set fileformat=unix

" map ; to : , so that's easier to type commands
nnoremap ; :


" ---------------------------------------- Backup

" remove those pesky ~.un .. .swp files from littering filesystem
" from http://vim.wikia.com/wiki/Remove_swap_and_backup_files_from_your_working_directory
" Na maku trzeba jeszcze zrobic $VIMRUNTIME chown hrutkows i moze chmod 755
" aby mogl tam zapisywac
silent execute '!mkdir "'.$VIMRUNTIME.'/temp" 2> /dev/null'
" silent execute '!rm "'.$VIMRUNTIME.'/temp/*~" 2> /dev/null'
set backupdir=$VIMRUNTIME/temp//
set directory=$VIMRUNTIME/temp//
set undodir=$VIMRUNTIME/temp//


" ---------------------------------------- Filetypes

filetype plugin indent on

autocmd FileType javascript nnoremap <buffer> <localleader>c I//<esc>
autocmd FileType python nnoremap <buffer> <localleader>c I#<esc>
autocmd FileType cpp,h nnoremap <buffer> <localleader>c I//<esc>

autocmd FileType python :iabbrev <buffer> iff if:<left>
autocmd FileType cpp :iabbrev <buffer> iff if ()<cr> {<cr>}

" ---------------------------------------- mappings

" move the current line up
noremap - ddkP

" move the current line down
noremap _ ddp

" ctrl+s = save in insert mode
noremap <c-s> <esc>:update<CR>


" -------------- normal mode

" press ctrl+N twice to toggle line numbers
nnoremap <C-N><C-N> :set invnumber<CR>

"This unsets the last search pattern register by hitting return
nnoremap <CR> :noh<CR><CR>

"ehp will edit vimrc
nnoremap ehp :vsplit $MYVIMRC<cr>

"rhp will reload vimrc
nnoremap rhp :source $MYVIMRC<cr>


" overwrite U (undo last modified line) to have the redo
nnoremap U <c-r>

" surround the current word in double quotes
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
" and single quotes
nnoremap <leader>' viw<esc>a'<esc>hbi'<esc>lel

" --------------- insert mode

" faster way to exit insert mode
inoremap jk <esc>

" delete current line in insert mode by pressing control+D, no need to leave insert mode
inoremap <c-d> <esc>ddi


" insert mode: ctrl+u to uppercase the current word
inoremap <c-u> <esc>viwUi


" --------------- visual mode


" --------------- Abbreviations

iabbrev adn and
iabbrev koshmaar@ koshmaar@poczta.onet.pl


" --------------- Cheat sheet

"set list   show tabs
" :set paste , potem :set nopaste

"highlight Cursor guifg=white guibg=black
"highlight iCursor guifg=white guibg=steelblue
"set guicursor=n-v-c:block-Cursor
"set guicursor+=i:ver100-iCursor
"set guicursor+=n-v-c:blinkon0
"set guicursor+=i:blinkwait10
"
"
"let &t_ti.="\e[1 q"
"let &t_SI.="\e[5 q"
"let &t_EI.="\e[1 q"
"let &t_te.="\e[0 q"

if &term =~ "xterm\\|rxvt"
  " use an orange cursor in insert mode
  let &t_SI = "\<Esc>]12;orange\x7"
  " use a red cursor otherwise
  let &t_EI = "\<Esc>]12;red\x7"
  silent !echo -ne "\033]12;red\007"
  " reset cursor when vim exits
  autocmd VimLeave * silent !echo -ne "\033]112\007"
  " use \003]12;gray\007 for gnome-terminal
endif


if &term =~ '^xterm'
  " solid underscore
  let &t_SI .= "\<Esc>[4 q"
  " solid block
  let &t_EI .= "\<Esc>[2 q"
  " 1 or 0 -> blinking block
  " 3 -> blinking underscore
  " Recent versions of xterm (282 or above) also support
  " 5 -> blinking vertical bar
  " 6 -> solid vertical bar
endif




