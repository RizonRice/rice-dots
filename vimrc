filetype plugin indent on
let g:mapleader = "\<Space>"

" toggle fold under cursor with `za`
" open all folds with `zR`
" close all folds with `zM`
" run `:help fold` for more fold binds
" delete this when you've memorized those binds

" push `K` with cursor on a setting to find more info about it

" {{{ plugins
let s:configdir = '.vim'
if has('nvim') | let s:configdir = '.config/nvim' | endif

if empty(glob('~/' . s:configdir . '/autoload/plug.vim'))
  silent call system('mkdir -p ~/' . s:configdir . '/{autoload,bundle,cache,undo,backups,swaps}')
  silent call system('curl -fLo ~/' . s:configdir . '/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
  execute 'source  ~/' . s:configdir . '/autoload/plug.vim'
  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/' . s:configdir . '/bundle')
Plug 'tpope/vim-unimpaired'            " change buffers with `[b` or `]b` push K with cursor in unimpaired for more help
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'            " use gcc to uncomment lines or folds
" Plug 'justinmk/vim-sneak' " {{{      " enable f/F/t/T/;/, to work across lines
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
Plug 'chilicuil/vim-sprunge' " {{{
  " uncomment the line below to use `ix.io`
  " let g:sprunge_cmd = 'curl -s -n -F "f:1=<-" http://ix.io'
" }}}
Plug 'noahfrederick/vim-noctu'

" some suggested plugins to try
" make sure to run `:PlugInstall` when you add new plugins

Plug 'tpope/vim-surround'
" Plug 'wellle/targets.vim'
" Plug 'kana/vim-textobj-user'
" Plug 'thinca/vim-textobj-between'
" Plug 'Raimondi/delimitMate'
call plug#end()
" }}}

" {{{ general settings
set hidden
set number                 " unimpaired lets you toggle this with `con`
set relativenumber         " unimpaired lets you toggle this with `cor`
set autoindent
set backspace=indent,eol,start
set smarttab
set nrformats-=octal
set ttimeout
set ttimeoutlen=100
set incsearch
set laststatus=1
set nowrap
" set wrap linebreak
set showmode
set showcmd
set foldmethod=marker foldtext=MyFoldText()
set ruler rulerformat=%32(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
execute 'set fillchars=stl:\ ,stlnc:\ ,vert:\ ,fold:\ ,diff:\ '
set list listchars=tab:\›\ ,trail:★,extends:»,precedes:«,nbsp:•
set wildmenu
set lazyredraw
set autoread
set shortmess+=I
set modeline modelines=2
set sessionoptions-=options
set undofile undodir=~/.vim/undo undoreload=1000
set undolevels=1000               " make undo persistent
set backupdir=~/.vim/backups
set directory=~/.vim/swaps

colorscheme noctu

" vim doesn't play nice with fish 
if &shell =~# 'fish$'
  set shell=/bin/bash
endif

" ^L will redraw the screen and also clear searches
nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

" make `Y` behave like more like `C` and `D`
nnoremap Y y$

" list buffers with <Space>b and prompt to switch buffers
exec 'nnoremap <leader>b <Esc>:ls<CR>:b '

" when searching with n or N open folds and center the line
nnoremap n nzvzz
nnoremap N Nzvzz

" }}}

" {{{ autocmds
augroup VIM
  autocmd!

  " enable wor-wrap and spell-check for text and markdown files
  autocmd FileType markdown,text
  \ setlocal nolist spell wrap linebreak

  " source vimrc when working on it
  autocmd BufWritePost *vimrc
  \ source %
  
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
