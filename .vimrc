""" only needed without vim-dart-plugin
""" adding dart support
"augroup dart
"  autocmd!
"  autocmd BufRead,BufNewFile *.dart set filetype=dart
"augroup END
"""

set encoding=utf-8
scriptencoding=utf-8

" TODO first define a good leader
" set <leader> to "ö"
let mapleader = "ö"

"
" Vundle - Vim plugin manager
"
set nocompatible
filetype off                " required by Vundle
set shellslash

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vim/bundle')
" alternatively, pass a path where Vundle should install plugins
" call vundle#begin('~/some/path/here')

if exists(':Plugin')
  " let Vundle manage Vundle, required
  Plugin 'VundleVim/Vundle.vim'

  Plugin 'christoomey/vim-tmux-navigator'

  Plugin 'gelguy/wilder.nvim'

  Plugin 'ctrlpvim/ctrlp.vim'

  Plugin 'chriskempson/base16-vim'

  Plugin 'vim-airline/vim-airline'
  Plugin 'vim-airline/vim-airline-themes'

  Plugin 'preservim/nerdtree'
  Plugin 'Xuyuanp/nerdtree-git-plugin'

  Plugin 'sgur/vim-editorconfig'

  " both are necessary
  Plugin 'godlygeek/tabular'
  Plugin 'plasticboy/vim-markdown'

  Plugin 'dense-analysis/ale'

  Plugin 'preservim/tagbar'

  Plugin 'jayli/vim-easycomplete'
  "" install language servers:
  "" * apt install clangd
  Plugin 'SirVer/ultisnips'

  " vim-devicons should be loaded last
  Plugin 'ryanoasis/vim-devicons'
endif

" All of your Plugins must be added before the following line
call vundle#end()           " required by Vundle
filetype plugin indent on   " required by Vundle
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList - lists configured plugins
" :PluginInstall - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

"""
""" Configuration:  Plugin 'christoomey/vim-tmux-navigator'
"""
let g:tmux_navigator_no_mappings = 1

""" get the keyboard code use: "sed -n l"

""" Alt + Arrow Keys
nnoremap <silent> <Esc>[1;3D :TmuxNavigateLeft<cr>
nnoremap <silent> <Esc>[1;3B :TmuxNavigateDown<cr>
nnoremap <silent> <Esc>[1;3A :TmuxNavigateUp<cr>
nnoremap <silent> <Esc>[1;3C :TmuxNavigateRight<cr>

""" If the tmux window is zoomed, keep it zoomed when moving from Vim to another pane
let g:tmux_navigator_preserve_zoom = 1

""" Shift + Arrow Keys
nnoremap <silent> <Esc>[1;2D :vertical resize +1<cr>
nnoremap <silent> <Esc>[1;2B :resize +1<cr>
nnoremap <silent> <Esc>[1;2A :resize -1<cr>
nnoremap <silent> <Esc>[1;2C :vertical resize -1<cr>

"""
""" Configuration: Plugin 'gelguy/wilder.nvim'
"""
call wilder#setup({
      \ 'modes': [':', '/', '?'],
      \ 'enable_cmdline_enter': 0,
      \ })
" Use wilder#wildmenu_lightline_theme() if using Lightline
" 'highlights' : can be overriden, see :h wilder#wildmenu_renderer()
" TODO: highlight color is currently red should be changed <10.12.22, dreknix>
call wilder#set_option('renderer', wilder#wildmenu_renderer(
      \ wilder#wildmenu_airline_theme({
      \   'highlights': {},
      \   'highlighter': wilder#basic_highlighter(),
      \   'separator': '  ',
      \ })))

"""
""" Configuration: Plugin 'kien/ctrlp.vim'
"""
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
" 'r' - the nearest ancestor that contains one of these directories or files:
"       .git .hg .svn .bzr _darcs, and your own root markers defined with the
"       g:ctrlp_root_markers option.
" 'a' - like 'c', but only applies when the current working directory outside
"       of CtrlP isn't a direct ancestor of the directory of the current file.
let g:ctrlp_working_path_mode = 'ra'
" Exclude files or directories using Vim's wildignore:
set wildignore+=*/tmp/*,*.so,*.swp,*~,*.bak,*.zip
" Exclude files or directories using CtrlP option
" TODO: add option for ignore also .gitignore files <10.12.22, dreknix>
let g:ctrlp_custom_ignore = {
	\ 'dir':  '\v[\/]\.(git|hg|svn)$',
	\ 'file': '\v\.(exe|so|dll)$',
	\ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
	\ }

"""
""" Configuration: Plugin 'chriskempson/base16-vim'
"""
if !has('gui_running')
  set t_Co=256
  set termguicolors
endif

syntax enable

" Fix highlighting for spell checks in terminal
function! s:base16_customize() abort
  " Colors: https://github.com/chriskempson/base16/blob/master/styling.md
  " Arguments: group, guifg, guibg, ctermfg, ctermbg, attr, guisp
  call Base16hi("SpellBad",   "", "", "", g:base16_cterm02, "", "")
  call Base16hi("SpellCap",   "", "", "", g:base16_cterm02, "", "")
  call Base16hi("SpellLocal", "", "", "", g:base16_cterm02, "", "")
  call Base16hi("SpellRare",  "", "", "", g:base16_cterm02, "", "")
endfunction

augroup on_change_colorschema
  autocmd!
  autocmd ColorScheme * call s:base16_customize()
augroup END

"""
""" Configuration: Plugin 'chriskempson/base16-vim'
"""
"
" configure plugin base16-vim and base16-shell
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  set background=dark
  source ~/.vimrc_background
endif
" end base16-vim

"""
""" Configuration: Plugin 'vim-airline/vim-airline'
"""
set noshowmode     " show no mode information
let g:airline_powerline_fonts = 1
" do not show spell info in status line
let g:airline_detect_spell=0
" extensions
let g:airline#extensions#tabline#enabled = 1  " enable a tabline for buffers
let g:airline#extensions#tabline#switch_buffers_and_tabs = 1

"""
""" Configuration: Plugin 'vim-airline/vim-airline-themes'
"""
let g:airline_theme='base16'

"""
""" Configuration: Plugin 'preservim/nerdtree'
"""
nnoremap <Leader>f :NERDTreeToggle<Enter>
nnoremap <silent> <Leader>v :NERDTreeFind<CR>
augroup nerdtree
  let NERDTreeIgnore = ['\.aux$','\.bbl$','\.blg$','\.hsh$','\.log$','\.nav$','\.out$','\.snm$','\.toc$','\.upa$','\.vrb$','\.vtc$','\.pdf$','\~$','\.bak$','\.swp$']
  " open NERDTree on start if no argument was given
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 0 && !exists("s:std_in") && v:this_session == "" | NERDTree | endif
  " close NERDTree if it the last buffer
  autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END

"""
""" Configuration: Plugin 'Xuyuanp/nerdtree-git-plugin'
"""

"""
""" Configuration: Plugin 'sgur/vim-editorconfig'
"""
" Softtabs, 2 spaces
set tabstop=2
set softtabstop=0
set shiftwidth=2
set shiftround
set expandtab
" check which plugin or file set the variable
":verbose set tabstop

if has("autocmd")
  autocmd BufRead,BufNewFile Makefile*   :set noexpandtab
endif

let g:editorconfig_blacklist = {
      \ 'filetype': ['git.*', 'fugitive'],
      \ 'pattern': ['\.un~$'] }
" editorconfig_root_chdir is dangerous since it makes a lcd to change
" the direcory and breaks so several other vim settings
"let g:editorconfig_root_chdir = 1
let g:editorconfig_verbose = 1

"""
""" Configuration: Plugin 'godlygeek/tabular'
"""

"""
""" Configuration: Plugin 'plasticboy/vim-markdown'
"""
let g:vim_markdown_no_default_key_mappings = 1 " disable key bindings
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_no_extensions_in_markdown = 1

"""
""" Configuration: Plugin 'dense-analysis/ale'
"""
" see below:
" nnoremap <F5> :ALEToggle<CR>
" inoremap <ESC><F5> :ALEToggle<CR>i

let g:ale_completion_enabled = 1
let g:ale_sign_column_always = 1
let g:ale_sign_error = ''
let g:ale_sign_warning = ''
let g:ale_sign_info = ''
highlight ALEErrorSign ctermfg=9 ctermbg=18 guifg=#cc6666 guibg=#373b41
highlight ALEWarningSign ctermfg=11 ctermbg=18 guifg=#f0c674 guibg=#373b41
highlight ALEInfoSign ctermfg=10 ctermbg=18 guifg=#b5bd68 guibg=#373b41
" Set this. Airline will handle the rest.
let g:airline#extensions#ale#enabled = 1
"
" INFORMATION
" Setting g:ale_linters and g:ale_fixers in the filetype specific file in
" ~/.vim/after/ftplugin/filetype.vim
"
" Only run linters named in g:ale_linters settings.
let g:ale_linters_explicit = 1
" Enable fixers at writing file
let g:ale_fix_on_save = 1
" Map keys CTRL-j and CTRL-k to moving between errors
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

"""
""" Configuration: Plugin 'preservim/tagbar'
"""
" see below:
" nnoremap <F8> :TagbarToggle<CR>
" inoremap <ESC><F8> :TagbarToggle<CR>i

"""
""" Configuration: Plugin 'SirVer/ultisnips'
"""
" Helper Function to get line comment character
function GetCommentMarker()
  if len(split(&l:commentstring, '%s')) == 1
    " if 'commentstring' xx%sxx contains no end part
    return split(&l:commentstring, '%s')[0]
  elseif match(&l:comments, '\v(,|^):[^,:]*(,|$)')
    " if 'comments' contains ',:xxx,'
    return matchstr(&l:comments, '\v(,|^):\zs[^,:]*\ze(,|$)')
  else
    echoerr "unable to find line comment marker."
  endif
endfunction
" Some variables need default value
if !exists("g:snips_author")
    let g:snips_author = "dreknix"
endif
if !exists("g:snips_email")
    let g:snips_email = "dreknix@proton.me"
endif
if !exists("g:snips_github")
    let g:snips_github = "https://github.com/dreknix"
endif
" Use <tab> key
"let g:UltiSnipsExpandTrigger="<tab>"
"let g:UltiSnipsJumpForwardTrigger="<tab>"
"let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

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

" file marks
" define a mark for every kind of file
" jump with e.g. 'C to the latest C buffer
augroup file_marks
"Xautocmd!
"Xautocmd BufLeave *.c    normal! mC
"Xautocmd BufLeave *.tex  normal! mL
augroup END


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
" <F5> - toogle ALE signs in gutter
nnoremap <F5> :ALEToggle<CR>
inoremap <ESC><F5> :ALEToggle<CR>i
" <F8> - toogle Tagbar
nnoremap <F8> :TagbarToggle<CR>
inoremap <ESC><F8> :TagbarToggle<CR>i

" move between ALE linting errors/warnings/infos
nnoremap ]r :ALENextWrap<CR>
nnoremap [r :ALEPreviousWrap<CR>

" <C-L> (redraw screen) - turn off search highlighting until next search
nnoremap <C-L> :nohlsearch<CR><C-L>


" juggling with buffers
set wildcharm=<C-z>
nnoremap <leader>b :buffer <C-z><S-Tab>
nnoremap <leader>B :sbuffer <C-z><S-Tab>

nnoremap <C-d> :bprevious<CR>
nnoremap <C-c> :bnext<CR>

"" Tab completion
"" will insert tab at beginning of line,
"" will use completion if not at beginning
"set wildmode=list:longest,list:full
"function! InsertTabWrapper()
"    let col = col('.') - 1
"    if !col || getline('.')[col - 1] !~ '\k'
"        return "\<Tab>"
"    else
"        return "\<C-p>"
"    endif
"endfunction
"inoremap <Tab> <C-r>=InsertTabWrapper()<CR>
"inoremap <S-Tab> <C-n>


"
" Autocorrect dictionary
"
abbr ture true
abbr flase false

" Enable project specifix .vimrc files (secured)
set exrc
set secure

""" end of ~/.vimrc
