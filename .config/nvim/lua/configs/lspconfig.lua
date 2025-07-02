require("nvchad.configs.lspconfig").defaults()

local servers = {
  "clangd", "ansiblels", "docker_compose_language_service",
  "dockerls", "jsonls", "marksman", "yamlls", "pyright", "texlab",
}

vim.lsp.enable(servers)

-- lua_ls - diagnostics . globals = { "vim", "pandoc", "quarto" },
-- yamlls - filetypes = {'yaml', 'yaml.ansible', 'yaml.docker-compose'},
