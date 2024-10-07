---@type ChadrcConfig
local M = {}

local highlights = require "highlights"

M.base46 = {
  theme_toggle = {
    'one_light',
    'catppuccin',
  },
  theme = 'catppuccin',

  hl_override = highlights.override,
  hl_add = highlights.add,
}

M.ui = {
  statusline = {
    theme = 'default',  -- default/vscode/vscode_colored/minimal
    separator_style = 'round',  -- default/round/block/arrow

    modules = {
      -- see: ~/.local/share/nvim/lazy/ui/lua/nvchad/stl
      cursor = function()
        return "%#St_pos_sep#%#St_pos_icon# %#St_pos_text# %04l:%03c "
      end,
    },
  },

}

M.mason = {
  pkgs = {
    -- general stuff
    'tree-sitter-cli',

    -- lua stuff
    'lua-language-server',
    'stylua',

    -- web dev stuff
    'css-lsp',
    'html-lsp',
    'prettier',

    -- C/C++ stuff
    'clangd',
    'clang-format',
    'codelldb',

    -- shell stuff
    'ansible-language-server',
    'bash-language-server',
    'docker-compose-language-service',
    'dockerfile-language-server',
    'hadolint',
    'jsonlint',
    'json-lsp',
    'marksman',
    'markdownlint',
    'shellcheck',
    'yaml-language-server',
    'yamllint',

    -- Python stuff
    'pyright',
    'flake8',
    'black',
    'pylint',
    'mypy',
    'ruff',
    'debugpy',

    -- TeX, LaTeX stuff
    'texlab',
  },
}

return M
