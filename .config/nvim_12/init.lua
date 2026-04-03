-- disable netrw at the very start of your init.lua
-- from nvim-tree plugin
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true
vim.pack.add({{
  src = "https://github.com/catppuccin/nvim",
  name = "catppuccin",
}})
require("catppuccin").setup({
  flavour = "mocha",
})
vim.cmd.colorscheme("catppuccin-nvim")

vim.opt.number = true

vim.opt.cmdheight = 1
vim.opt.showmode = false

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.pack.add({
  "https://github.com/nvim-tree/nvim-tree.lua",
})
vim.pack.add({
  "https://github.com/nvim-tree/nvim-web-devicons",
})

require("nvim-tree").setup({
  filters = {
    dotfiles = true,
  },
  renderer = {
    root_folder_label = false,
    group_empty = true,
  },
  view = {
    signcolumn = "no", -- Removes the left-side gutter used for git signs/diagnostics
  },
})

-- set highlight colors with `:NvimTreeHiTest`
vim.api.nvim_set_hl(0, 'NvimTreeEndOfBuffer', { fg = 'bg' })

vim.keymap.set("n", "<leader>e", function()
  require("nvim-tree.api").tree.toggle()
end, { desc = "Toggle NvimTree" })
