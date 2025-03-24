-- Set <space> as the leader key
-- Set :help mapleader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = false

require("config.options")

require("config.lazy")

require("keymaps")
