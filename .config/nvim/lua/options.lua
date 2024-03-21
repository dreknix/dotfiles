require "nvchad.options"

-- General Settings

-- highlight column textwidth+0 and textwidth+20
vim.opt.colorcolumn = '+0,+20'

-- LuaSnip uses rafamadriz/friendly-snippets
-- extend in snipmate format
vim.g.snipmate_snippets_path = vim.fn.stdpath 'config' .. '/lua/custom/snippets'

-- spell Settings
vim.opt.spelllang    = 'en_us,computer-science'
vim.opt.spellsuggest = 'fast'
vim.opt.spelloptions = 'camel'
vim.opt.spellfile    = vim.fn.stdpath 'config' .. '/lua/custom/after/spell/en.utf-8.add'

-- set the TeX flavor to LaTeX for filetype plugin (`:help ft-tex-plugin`)
vim.g.tex_flavor = 'latex'

--
-- https://neovim.io/doc/user/lua.html#vim.filetype
--
vim.filetype.add({
  pattern = {
    -- SSH config
    ['.*/.ssh/config.d/.*'] = 'sshconfig',
    -- rofi config
    ['.*/.*.rasi'] = 'css',
    -- Docker compose
    ['compose.ya?ml'] = 'yaml.docker-compose',
    ['docker-compose.ya?ml'] = 'yaml.docker-compose',
    -- Ansible
    ['.*/playbooks/.*.ya?ml'] = 'yaml.ansible',
    ['.*/playbooks/.*/.*.ya?ml'] = 'yaml.ansible',
    ['.*/roles/.*/tasks/.*.ya?ml'] = 'yaml.ansible',
    ['.*/roles/.*/handlers/.*.ya?ml'] = 'yaml.ansible',
  },
})

-- securing gopass
vim.api.nvim_create_augroup('gopass_buffer', { clear = true })
vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  group = 'gopass_buffer',
  pattern = {'/dev/shm/gopass*'},
  callback = function(ev)
    vim.opt_local.swapfile = false
    vim.opt_local.backup = false
    vim.opt_local.undofile = false
    vim.opt_local.shadafile = 'NONE'
  end
})

vim.api.nvim_create_augroup('custom_buffer', { clear = true })

-- highlight which lines are currently yanked (e.g. yy - hightlights current
-- line)
vim.api.nvim_create_autocmd('TextYankPost', {
  group = 'custom_buffer',
  pattern = '*',
  callback = function()
    vim.highlight.on_yank { timeout = 200 }
  end
})

-- jump to last position when opening a file
vim.api.nvim_create_autocmd('BufReadPost', {
  group = 'custom_buffer',
  pattern = '*',
  callback = function()
    local last_cursor_pos, last_line = vim.fn.line([['"]]), vim.fn.line("$")
    if last_cursor_pos > 1 and last_cursor_pos <= last_line then
      vim.fn.cursor(last_cursor_pos, 1)
    end
  end
})
