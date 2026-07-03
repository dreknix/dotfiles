require("nvchad.configs.lspconfig").defaults()

local nvlsp = require "nvchad.configs.lspconfig"

local servers = {
  "clangd",
  "ansiblels",
  "docker_compose_language_service",
  "dockerls",
  "jsonls",
  "marksman",
  "yamlls",
  -- "pyright",
  "texlab",
}

vim.lsp.enable(servers)

-- lua_ls - diagnostics . globals = { "vim", "pandoc", "quarto" },
-- yamlls - filetypes = {'yaml', 'yaml.ansible', 'yaml.docker-compose'},

vim.lsp.config("pyright", {
  on_init = nvlsp.on_init,
  on_attach = nvlsp.on_attach,
  capabilities = nvlsp.capabilities,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly", -- or 'workspace'
        useLibraryCodeForTypes = true,
        autoImportCompletions = true,
      },
    },
  },
})

vim.lsp.enable "pyright"
