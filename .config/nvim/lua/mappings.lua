require 'nvchad.mappings'

-- Disable mappings
local nomap = vim.keymap.del

nomap("n", "<C-h>")
nomap("n", "<C-l>")
nomap("n", "<C-j>")
nomap("n", "<C-k>")

local map = vim.keymap.set

-- switch between windows
map('n', '<A-Left>', '<cmd> TmuxNavigateLeft <CR>', { desc = 'Window left' })
map('n', '<A-Right>', '<cmd> TmuxNavigateRight <CR>', { desc = 'Window right' })
map('n', '<A-Down>', '<cmd> TmuxNavigateDown <CR>', { desc = 'Window down' })
map('n', '<A-Up>', '<cmd> TmuxNavigateUp <CR>', { desc = 'Window up' })

map('n', '<A-S-Left>', '<cmd> bprevious <CR>' , { desc = 'Previous tab' })
map('n', '<A-S-Right>', '<cmd> bnext <CR>' , { desc = 'Previous tab' })

map('n', '<C-S-Up>', '<cmd> cprev <CR>' , { desc = 'Previous Quicklist location' })
map('n', '<C-S-Down>', '<cmd> cnext <CR>' , { desc = 'Next Quicklist location' })

map('n', '<C-S-Left>', '<cmd> tabprevious <CR>' , { desc = 'Previous tab' })
map('n', '<C-S-Right>', '<cmd> tabnext <CR>' , { desc = 'Next tab' })

map('n', '<leader>y', '<cmd> tabedit README.md <CR>' , { desc = 'Open README.md in tab' })

map('n', '<F2>',
  function()
    vim.opt.list = not(vim.opt.list:get())
  end,
  { desc = 'toogle display of unprintable characters' })

map('n', '<F3>',
  function()
    vim.opt.number = not(vim.opt.number:get())
  end,
  { desc = 'toogle display of line numbers' })

map('n', '<F4>',
  function()
    vim.opt.relativenumber = not(vim.opt.relativenumber:get())
  end,
  { desc = 'toogle display of relative line numbers' })

map('n', '<F5>',
  function()
    local qf_exists = false
    for _, win in pairs(vim.fn.getwininfo()) do
      if win["quickfix"] == 1 then
        qf_exists = true
      end
    end
    if qf_exists == true then
      vim.cmd "cclose"
      return
    end
    if not vim.tbl_isempty(vim.fn.getqflist()) then
      vim.cmd "copen | wincmd p" -- open quickfix and stay in current window
    end
  end,
  { desc = 'toogle quickfix list' })
