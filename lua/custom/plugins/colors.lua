return {
  "rose-pine/neovim",
  version = "*",
  config = function()
    -- Lua
    require("rose-pine").setup({
      disable_background = true,
      disable_float_background = true,
    })
  end,
}
