-- from https://ramezanpour.net/post/2021/04/24/My-ultimate-Neovim-configuration-for-Python-development

-- Install vim-plug - https://github.com/junegunn/vim-plug
-- sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
--     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.config/nvim/plugged')

Plug('kien/ctrlp.vim')
Plug('scrooloose/nerdcommenter')
Plug('tmhedberg/matchit')
Plug('scrooloose/nerdtree', {on = {'NERDTreeToggle', 'NERDTree'}})
Plug('chriskempson/base16-vim')
Plug('vim-airline/vim-airline')
Plug('vim-airline/vim-airline-themes')
Plug('arcticicestudio/nord-vim')
Plug('sheerun/vim-polyglot')
Plug('tpope/vim-fugitive')
-- Intellisense engine
-- :CocInstall coc-docker
-- :CocInstall coc-git
-- :CocInstall coc-json
-- :CocInstall coc-pairs
-- :CocInstall coc-prettier
-- :CocInstall coc-pyright
-- :CocInstall coc-spell-checker
-- :CocInstall coc-yaml
Plug('neoclide/coc.nvim', {branch= 'release'})
Plug('ryanoasis/vim-devicons')

vim.call('plug#end')
-- End of vim-plug

vim.cmd('set t_Co=256')
vim.cmd('set termguicolors')
vim.cmd('let base16colorspace = 256')
vim.cmd('source ~/.vimrc_background')
local gset = vim.api.nvim_set_var
gset('airline_powerline_fonts', 1)
gset('airline_detect_spell', 0)
gset('airline#extensions#tabline#enabled', 1)
gset('airline#extensions#tabline#switch_buffers_and_tabs', 1)
gset('airline_theme', "base16")

vim.opt.listchars="tab:→ ,eol:↲,space:·"
