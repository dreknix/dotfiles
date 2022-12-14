-- from https://ramezanpour.net/post/2021/04/24/My-ultimate-Neovim-configuration-for-Python-development

-- Let's install it into ~/.local/share/nvim
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require("packer").startup({function(use)

  use 'wbthomason/packer.nvim'

  use 'kien/ctrlp.vim'
  use 'scrooloose/nerdcommenter'
  use 'tmhedberg/matchit'
  use 'scrooloose/nerdtree'
  use 'chriskempson/base16-vim'
  use 'vim-airline/vim-airline'
  use 'vim-airline/vim-airline-themes'
  use 'arcticicestudio/nord-vim'
  use 'sheerun/vim-polyglot'
  use 'tpope/vim-fugitive'
-- COC - Intellisense engine
-- install nodejs: curl -sL install-node.vercel.app/lts | sudo bash
-- install packages: sudo apt install clangd black flake8
-- :CocInstall coc-clangd
-- :CocInstall coc-docker
-- :CocInstall coc-git
-- :CocInstall coc-json
-- :CocInstall coc-pairs
-- :CocInstall coc-prettier
-- :CocInstall coc-pyright
-- :CocInstall coc-spell-checker
-- :CocInstall coc-yaml
  use { 'neoclide/coc.nvim', branch= 'release' }
  use 'ryanoasis/vim-devicons'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end

end,
config = {
  display = {
    open_fn = require('packer.util').float,
  }
}})
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
