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

return M
