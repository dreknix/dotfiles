-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local nvlsp = require("nvchad.configs.lspconfig")
local on_attach = nvlsp.on_attach
local on_init = nvlsp.on_init
local capabilities = nvlsp.capabilities

local lspconfig = require "lspconfig"

lspconfig.clangd.setup({
  on_attach = function (client, bufnr)
    client.server_capabilities.signatureHelpProvider = false
    on_attach(client, bufnr)
  end,
  on_init = on_init,
  capabilities = capabilities,
})

lspconfig.ansiblels.setup({
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
})

lspconfig.docker_compose_language_service.setup({
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  filetypes = {'yaml.docker-compose'},
})

lspconfig.dockerls.setup({
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
})

lspconfig.jsonls.setup({
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
})

lspconfig.marksman.setup({
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
})

lspconfig.yamlls.setup({
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  filetypes = {'yaml', 'yaml.ansible', 'yaml.docker-compose'},
})

lspconfig.pyright.setup({
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  filetypes = {'python'},
})

lspconfig.texlab.setup({
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
})
