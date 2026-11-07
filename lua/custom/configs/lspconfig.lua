local config = require "plugins.configs.lspconfig"
local on_attach = config.on_attach
local capabilities = config.capabilities

-- vim.lsp.enable() only accepts (name, enable). Server options have to be
-- registered with vim.lsp.config() first, otherwise they are silently ignored.
local function setup(server, opts)
  vim.lsp.config(
    server,
    vim.tbl_deep_extend("force", {
      on_attach = on_attach,
      capabilities = capabilities,
    }, opts or {})
  )

  vim.lsp.enable(server)
end

-- tsserver was renamed to ts_ls in nvim-lspconfig v2.
setup("ts_ls", {
  init_options = {
    preferences = {
      disableSuggestions = true,
    },
  },
})

setup("pyright", {
  filetypes = { "python" },
})

setup("gopls", {
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  settings = {
    gopls = {
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
    },
  },
})
