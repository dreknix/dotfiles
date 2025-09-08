local M = {
  filetype = {
    python = {
      -- require('formatter.filetypes.python').black
      -- from: https://github.com/mhartington/formatter.nvim/blob/master/lua/formatter/filetypes/python.lua
      function()
        local util = require("formatter.util")
        return {
          exe = "black",
          args = { "-q", "--fast", "--line-length=130", "--stdin-filename", util.escape_path(util.get_current_buffer_file_name()), "-" },
          stdin = true,
        }
      end
    },
    ['*'] = {
      require('formatter.filetypes.any').remove_trailing_whitespace
    },
  },
}

vim.api.nvim_create_autocmd({'BufWritePost'}, {
  command = 'FormatWriteLock'
})

return M
