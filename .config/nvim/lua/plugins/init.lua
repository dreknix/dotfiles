local overrides = require 'configs.overrides'

local plugins = {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = overrides.treesitter,
  },
  {
    'nvim-tree/nvim-tree.lua',
    opts = overrides.nvimtree,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = overrides.blankline,
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      { 'f3fora/cmp-spell' },
    },
    opts = {
      sources = {
        -- add all sources from NvChad before extend the list
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "nvim_lua" },
        { name = "path" },
        {
          name = 'spell',
          option = {
            keep_all_entries = false,
            enable_in_context = function()
              return true
            end,
          },
        },
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    config = function()
      require 'configs.lspconfig'
    end
  },
  {
    'mfussenegger/nvim-lint',
    event = 'VeryLazy',
    config = function()
      require 'configs.lint'
    end
  },
  {
    'mhartington/formatter.nvim',
    event = 'VeryLazy',
    opts = function()
      return require 'configs.formatter'
    end
  },
  {
    'christoomey/vim-tmux-navigator',
    lazy = false,
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end
  },
  {
    'klen/nvim-config-local',
    lazy = false,
    config = function()
      require('config-local').setup {
        -- Default options (optional)

        -- Config file patterns to load (lua supported)
        config_files = { '.nvim.lua', '.nvimrc', '.exrc' },

        -- Where the plugin keeps files data
        hashfile = vim.fn.stdpath('data') .. '/config-local',

        autocommands_create = true, -- Create autocommands (VimEnter, DirectoryChanged)
        commands_create = true,     -- Create commands (ConfigLocalSource, ConfigLocalEdit, ConfigLocalTrust, ConfigLocalIgnore)
        silent = false,             -- Disable plugin messages (Config loaded/ignored)
        lookup_parents = true,     -- Lookup config files in parent directories
      }
    end
  },
  {
    'rcarriga/nvim-notify',
    config = function()
      require("notify").setup {
        enabled = false,
      }
    end
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        signature = {
          enabled = false,
        }
      },
    },
  },
  {
    'mfussenegger/nvim-dap',
    keys = {
      -- see: http://www.lazyvim.org/extras/dap/core
      { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Toggle Breakpoint' },
    },
  },
  -- disable since MasonInstallAll is not installed
  -- {
  --   'jay-babu/mason-nvim-dap.nvim',
  --   event = 'VeryLazy',
  --   dependencies = {
  --     'williamboman/mason.nvim',
  --     'mfussenegger/nvim-dap',
  --     'nvim-neotest/nvim-nio',
  --   },
  --   opts = {
  --     handlers = {},
  --   },
  -- },
  {
    'rcarriga/nvim-dap-ui',
    event = 'VeryLazy',
    dependencies = {
      'mfussenegger/nvim-dap',
      'nvim-neotest/nvim-nio',
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')
      dapui.setup()
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end
    end
  },
  {
    'mfussenegger/nvim-dap-python',
    ft = 'python',
    dependencies = {
      'mfussenegger/nvim-dap',
      'rcarriga/nvim-dap-ui',
    },
    keys = {
      -- see: http://www.lazyvim.org/extras/dap/core
      { '<leader>dbr', function() require('dap-python').test_method() end, desc = 'Test method' },
    },
  },
}

return plugins
