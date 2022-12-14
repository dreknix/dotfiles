" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

set encoding=utf-8
scriptencoding=utf-8

" Set <space> as the leader key
let mapleader = " "

"
" vim-plug - Vim plugin manager
"
let data_dir = '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'

  Plug 'christoomey/vim-tmux-navigator'

  Plug 'gelguy/wilder.nvim'

  Plug 'ctrlpvim/ctrlp.vim'

  Plug 'chriskempson/base16-vim'

  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

  Plug 'preservim/nerdtree'
  Plug 'Xuyuanp/nerdtree-git-plugin'

  Plug 'sgur/vim-editorconfig'

  " both are necessary
  Plug 'godlygeek/tabular'
  Plug 'plasticboy/vim-markdown'

  Plug 'dense-analysis/ale'

  Plug 'preservim/tagbar'

  Plug 'davidhalter/jedi-vim' " Python Autocomplete

  Plug 'SirVer/ultisnips'

  " vim-devicons should be loaded last
  Plug 'ryanoasis/vim-devicons'

" Initialize plugin system
" - Automatically executes `filetype plugin indent on` and `syntax enable`.
call plug#end()
" You can revert the settings after the call like so:
"   filetype indent off   " Disable file-type-specific indentation
"   syntax off            " Disable syntax highlighting
"
" Brief help
" :PlugStatus  - check the status of plugins
" :PlugInstall - install or update plugins
" :PlugClean   - remove unlisted plugins

"""
""" Configuration of plugins in ~/.vim/plugin/config/{plugin-name}.vim
"""

"""
""" Configuration: non plugin settings
"""

" When editing a file, always jump to the last known cursor position.
" Don't do it for commit messages, when the position is invalid, or when
" inside an event handler (happens when dropping a file on gvim).
autocmd BufReadPost *
  \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

" turn off modelines in files - security
set modelines=0

" have at least 3 lines during scolling
set scrolloff=3

" motion with backspace between lines
set backspace=indent,eol,start

" show line numers left (with minimum size)
set number
set numberwidth=5

" highlight current line
set cursorline

" better command-line completion
" disable: using plugin wilder.nvim
"set wildmenu

" better ignorecase search
set ignorecase
set smartcase

" show partial commands in the last line of the screen
set showcmd

" highlight searches (use <C-L> to turn off highlighting)
set hlsearch

" highlight during typing a search string
set incsearch

" use one space, not two, after punctuation when joining lines
set nojoinspaces

" use system clipboard
set clipboard=unnamedplus
set mouse=a
noremap x "_x
noremap X "_x

" set the characters for the list view
" → u2192, ↲ u21b2, · u00b7
" space has been added since patch-7.4.710
if has("patch-7.4.710")
  set listchars=tab:→\ ,eol:↲,space:·
else
  set listchars=tab:→\ ,eol:↲
endif


" syntax highlighting for ~/.ssh/config.d/*
au BufNewFile,BufRead ~/.ssh/config.d/*  setf sshconfig

" syntax highlighting for *.rasi files (e.g. rofi config)
au BufNewFile,BufRead /*.rasi  setf css

"
" securing gopass
"
au BufNewFile,BufRead /dev/shm/gopass.* setlocal noswapfile nobackup noundofile

"
" Spell Checking and Word Completion
"

" Spell-check language
set spelllang=en_us

"
" Turn on spellchecking the ftplugin/filetype.vim file
"
" autocmd FileType filetype setlocal spell

" Set spellfile to location that is guaranteed to exist,
" can be symlinked to Dropbox or kept in Git
" and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim/spell-en.utf-8.add

" Autocomplete with dictionary words when spell check is on
set complete+=kspell


"
" Key mappings
"

" TODO improve german keyboard, e.g.
map ö [
map ä ]
map Ö {
map Ä }
map ß /

" arrow keys
"nnoremap <Up>    <Nop>
"nnoremap <Down>  <Nop>
"nnoremap <Left>  <Nop>
"nnoremap <Right> <Nop>
"inoremap <Up>    <Nop>
"inoremap <Down>  <Nop>
"inoremap <Left>  <Nop>
"inoremap <Right> <Nop>

" function keys (windows keyboard -> press '[f] Umsch' first

" <F1> - is help key for vim

" <F2> - toogle display of unprintable characters (see `listchars`)
nnoremap <F2> :set list!<CR>
inoremap <F2> <ESC>:set list!<CR>i
" <F3> - toogle display of line numbers (see `numberwidth`)
nnoremap <F3> :set number!<CR>
inoremap <F3> <ESC>:set number!<CR>i
" <F4> - toogle display of relative line numbers
nnoremap <F4> :set relativenumber!<CR>
inoremap <F4> <ESC>:set relativenumber!<CR>i

" <C-L> (redraw screen) - turn off search highlighting until next search
nnoremap <C-L> :nohlsearch<CR><C-L>


" juggling with buffers
set wildcharm=<C-z>
nnoremap <leader>b :buffer <C-z><S-Tab>
nnoremap <leader>B :sbuffer <C-z><S-Tab>

nnoremap <C-d> :bprevious<CR>
nnoremap <C-c> :bnext<CR>

"
" Autocorrect dictionary
"
abbr ture true
abbr flase false

" Enable project specifix .vimrc files (secured)
set exrc
set secure

""" end of ~/.vimrc
