local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local null_ls = require('null-ls')

-- Explicitly add Mason bin to PATH using absolute path for reliability
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
vim.env.PATH = mason_bin .. ":" .. vim.env.PATH

local opts = {
  sources = {
    null_ls.builtins.formatting.gofumpt,
    null_ls.builtins.formatting.goimports_reviser,
    null_ls.builtins.formatting.black,
    null_ls.builtins.diagnostics.mypy.with({
      command = "mypy",
    }),
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.prettier,
    --    null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.diagnostics.eslint,


  },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({
        group = augroup,
        buffer = bufnr,
      })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
}
return opts
