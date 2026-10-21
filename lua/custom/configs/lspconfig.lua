local config = require("plugins.configs.lspconfig")
local on_attach = config.on_attach
local capabilities = config.capabilities

-- local lspconfig = require("lspconfig")
local util = require "lspconfig.util"

vim.lsp.enable("tsserver", {
  on_attach = on_attach,
  capabilities = capabilities,
  init_options = {
    preferences = {
      disableSuggestions = true,
    }
  }
})


vim.lsp.enable("pyright", {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "python" },
})


vim.lsp.enable("gopls", {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    completedUnimported = true,
    usePlaceholders = true,
    analysis = {
      unusedparams = true,
    }
  }
})
