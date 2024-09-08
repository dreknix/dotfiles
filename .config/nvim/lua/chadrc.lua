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

  statusline = {
    theme = 'default',  -- default/vscode/vscode_colored/minimal
    separator_style = 'block',  -- default/round/block/arrow

    overriden_modules = function(modules)
      modules[10] = (function()
        local left_sep = '%#St_pos_sep#' .. '█' .. '%#St_pos_icon#' .. ' '
        local current_column = vim.fn.col '.'
        local current_line = vim.fn.line '.'
        local total_line = vim.fn.line '$'
        local percentage = math.modf((current_line / total_line) * 100)
        local text = string.format('%2d', percentage) .. '%%'

        text = (current_line == 1 and 'Top') or text
        text = (current_line == total_line and 'Bot') or text

        text = string.format('%3s %-3d', text, current_column)

        return left_sep .. '%#St_pos_text#' .. ' ' .. text .. ' '
      end)()
    end,
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
