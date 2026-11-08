-- Compatibility shim for nvim-treesitter (master branch) on Neovim 0.12+.
--
-- Neovim 0.12 changed the treesitter query predicate/directive API: handlers
-- registered with `all = false` now receive capture *lists* instead of the
-- last captured node. nvim-treesitter's master branch (which is frozen for
-- Neovim 0.11) still expects the old, flattened behavior and crashes while
-- parsing markdown code fences, e.g.:
--
--   attempt to call method 'range' (a nil value)  (query_predicates.lua)
--
-- Restore the old wrapper for plugins that explicitly pass `all = false`.
if vim.fn.has "nvim-0.12" == 1 and not vim.g.nvim_treesitter_012_compat then
  vim.g.nvim_treesitter_012_compat = true

  local query = require "vim.treesitter.query"

  local function flatten_handler(handler)
    return function(captures, ...)
      local match = {}
      for capture, nodes in pairs(captures) do
        if type(capture) == "number" then
          match[capture] = nodes[#nodes]
        end
      end
      return handler(match, ...)
    end
  end

  local add_predicate = query.add_predicate
  query.add_predicate = function(name, handler, opts)
    if type(opts) == "table" and opts.all == false then
      handler = flatten_handler(handler)
    end
    return add_predicate(name, handler, opts)
  end

  local add_directive = query.add_directive
  query.add_directive = function(name, handler, opts)
    if type(opts) == "table" and opts.all == false then
      handler = flatten_handler(handler)
    end
    return add_directive(name, handler, opts)
  end
end

-- Neovim 0.12 regression: on the first file opened after startup, the built-in
-- filetype detection runs but fails to apply the detected filetype (`:setf`
-- inside its BufRead callback is a no-op). That leaves `filetype` empty, so
-- treesitter, LSP, and render-markdown never activate for that buffer.
if vim.fn.has "nvim-0.12" == 1 then
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("CustomFiletypeFallback", { clear = true }),
    callback = function(args)
      if vim.bo[args.buf].filetype ~= "" then
        return
      end

      local ft = vim.filetype.match { filename = args.file, buf = args.buf }
      if ft then
        -- Assigning the option directly also emits FileType.
        vim.bo[args.buf].filetype = ft
      end
    end,
  })
end
