"""
""" Configuration of plugins in
"""
"""     ~/.vim/plugin/config/{plugin-name}.vim
"""
""" or after the plugin is loaded in
"""
"""     ~/.vim/after/plugin/config/{plugin-name}.vim
"""

" Brief help
" :PlugStatus  - check the status of plugins
" :PlugInstall - install or update plugins
" :PlugClean   - remove unlisted plugins

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
