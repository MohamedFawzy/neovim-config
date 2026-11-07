local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local null_ls = require "null-ls"

-- eslint was moved to none-ls-extras; null_ls.builtins.diagnostics.eslint no
-- longer exists and made none-ls fail to load.
local eslint = require "none-ls.diagnostics.eslint"

-- Explicitly add Mason bin to PATH using absolute path for reliability
local mason_bin = vim.fn.stdpath "data" .. "/mason/bin"
vim.env.PATH = mason_bin .. ":" .. vim.env.PATH

local opts = {
  sources = {
    null_ls.builtins.formatting.gofumpt,
    null_ls.builtins.formatting.goimports_reviser,
    null_ls.builtins.formatting.black,
    null_ls.builtins.diagnostics.mypy.with {
      command = "mypy",
    },
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.prettier,
    eslint,
  },
  on_attach = function(client, bufnr)
    if client:supports_method "textDocument/formatting" then
      vim.api.nvim_clear_autocmds {
        group = augroup,
        buffer = bufnr,
      }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          -- Only format through null-ls so gopls/pyright/ts_ls do not race it.
          vim.lsp.buf.format { bufnr = bufnr, id = client.id, timeout_ms = 2000 }
        end,
      })
    end
  end,
}
return opts
