filetype plugin indent on
let g:mapleader = "\<Space>"

" K should show help of word under cursor
" toggle fold under cursor with `za`/`zA`
" increase/decrease fold level with `zr`/`zm`
" toggle all folds with `zR`/`zM`
" run `:help fold` for more fold binds
" search help files with :helpgrep

" {{{ plugins
let s:configdir = '~/.vim'
if has('nvim') | let s:configdir = '~/$XDG_CONFIG_HOME/nvim' | endif

if empty(glob(s:configdir . '/autoload/plug.vim'))
  silent call system('mkdir -p ' . s:configdir . '/{autoload,bundle,cache,undo,backups,swaps}')
  silent call system('curl -fLo ' . s:configdir . '/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
  execute 'source  ' . s:configdir . '/autoload/plug.vim'
endif

" make sure your terminal supports clickable links
call plug#begin(s:configdir . '/bundle')
Plug 'https://github.com/tpope/vim-unimpaired'                   " lots of extra bindings. push K with cursor on 'unimpaired'
Plug 'https://github.com/jiangmiao/auto-pairs'                   " adds matching chars
Plug 'https://github.com/tpope/vim-endwise'                      " adds matching words
Plug 'https://github.com/tpope/vim-repeat'                       " makes `.` better
Plug 'https://github.com/tpope/vim-commentary'                   " use `gcc` or `gc<motion>` to toggle commenting lines or folds
Plug 'https://github.com/tpope/vim-fugitive' " {{{                 git commands
  nnoremap <Leader>gs <Esc>:Gstatus<CR>
  nnoremap <Leader>gd <Esc>:Gdiff<CR>
  nnoremap <Leader>gc <Esc>:Gcommit<CR>
  nnoremap <Leader>gb <Esc>:Gblame<CR>
  nnoremap <Leader>gp <Esc>:Gpush<CR>
" }}}
Plug 'https://github.com/chilicuil/vim-sprunge' " {{{              paste with :Sprunge
  " let g:sprunge_cmd = 'curl -s -n -F "f:1=<-" http://ix.io'    " uncomment with `gcc` to use `ix.io`
" }}}
Plug 'https://github.com/noahfrederick/vim-noctu'                " basic terminal styling

" some suggested plugins to try
" make sure to run `:PlugInstall` when you add new plugins
" Plug 'https://github.com/tpope/vim-surround'
" Plug 'https://github.com/wellle/targets.vim'
" Plug 'https://github.com/kana/vim-textobj-user'
" Plug 'https://github.com/thinca/vim-textobj-between'
" Plug 'https://github.com/jeetsukumaran/vim-filebeagle' " {{{   " mini file-explorer
"   let g:filebeagle_suppress_keymaps = 1
"   map <silent> - <Plug>FileBeagleOpenCurrentBufferDir
" " }}}
" Plug 'https://github.com/justinmk/vim-sneak' " {{{             " enable f/F/t/T/;/, to work across lines
"   map <silent> f <Plug>Sneak_f
"   map <silent> F <Plug>Sneak_F
"   map <silent> t <Plug>Sneak_t
"   map <silent> T <Plug>Sneak_T
"   map <silent> ; <Plug>SneakNext
"   map <silent> , <Plug>SneakPrevious
"   augroup SneakPluginColors
"     autocmd!
"     autocmd ColorScheme * hi SneakPluginTarget
"     \ guifg=black guibg=red ctermfg=black ctermbg=red
"     autocmd ColorScheme * hi SneakPluginScope
"     \ guifg=black guibg=yellow ctermfg=black ctermbg=yellow
"   augroup END
" " }}}
call plug#end()
" don't forget to occasionally update plugins with :PlugUpgrade
" }}}

" {{{ general settings
set hidden
set number                        " unimpaired lets you toggle this with `con`
set relativenumber                " unimpaired lets you toggle this with `cor`
set autoindent
set backspace=indent,eol,start
set smarttab
set nrformats-=octal
set ttimeout
set ttimeoutlen=100
set incsearch
set laststatus=1
set nowrap
set showmode
set magic                         " more sane regex
set showcmd
set foldmethod=marker foldtext=MyFoldText()
set ruler rulerformat=%32(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
execute 'set fillchars=stl:\ ,stlnc:\ ,vert:\ ,fold:\ ,diff:\ '
set list                          " toggle lith `col`
set listchars=tab:\›\ ,trail:★,extends:»,precedes:«,nbsp:•
set wildmenu
set lazyredraw
set autoread
set shortmess+=I
set modeline modelines=2
set sessionoptions-=options
set undofile undodir=~/.vim//undo undoreload=1000
set undolevels=1000               " make undo persistent
set backupdir=~/.vim//backups
set directory=~/.vim//swaps

colorscheme noctu

" integrate with ag and ack
if executable('ag')
  set grepprg=ag\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow
  set grepformat=%f:%l:%c:%m
elseif executable('ack')
  set grepprg=ack\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow\ $*
  set grepformat=%f:%l:%c:%m
endif

" fish is weird in vim
if &shell =~# 'fish$'
  set shell=/bin/bash
endif

" ^L will redraw the screen and also clear searches
nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

" make `Y` behave like more like `C` and `D`
nnoremap Y y$

" list buffers with <Space>b and prompt to switch buffers
nnoremap <leader>b <Esc>:ls<CR>:b<space>

" when searching with n or N, open folds and center the line
nnoremap n nzvzz
nnoremap N Nzvzz

" }}}

" {{{ autocmds
augroup VIM
  autocmd!

  " enable word-wrap and spell-check for text and markdown files
  autocmd FileType markdown,text
  \ setlocal nolist spell wrap linebreak

  " source vimrc when working on it
  " autocmd BufWritePost *vimrc
  " \ source %

  " make K open :help on the file under cursor
  autocmd FileType vim
  \ set keywordprg=:help

  " some options for buffers not attached to files
  autocmd BufEnter *
  \ if &buftype != '' |
  \   setlocal nolist nospell nocursorcolumn nocursorline colorcolumn=0 |
  \   nnoremap <silent><buffer> q <Esc>:bd<CR> |
  \ endif

 " push help windows to the right and makes them 80 chars wide
  autocmd FileType help
  \ wincmd L |
  \ vert resize 80 |
  \ setlocal nospell
augroup END
" }}}

" {{{ functions

function! MyFoldText() abort " {{{
  " courtesy Steve Losch
  let line = getline(v:foldstart)
  let nucolwidth = &fdc + &number * &numberwidth
  let windowwidth = winwidth(0) - nucolwidth - 3
  let foldedlinecount = v:foldend - v:foldstart
  let onetab = strpart('          ', 0, &tabstop)
  let line = substitute(line, '\t', onetab, 'g')
  let line = strpart(line, 0, windowwidth - 2 - len(foldedlinecount))
  let fillcharcount = windowwidth - len(line) - len(foldedlinecount) - 2
  return line . ' ' . repeat(' ', fillcharcount)  . ' '. foldedlinecount
endfunction
" }}}

" }}}
