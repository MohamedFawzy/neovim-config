return {
  "projekt0n/github-nvim-theme",
  version = "v0.0.7",
  config = function()
    -- Lua
    require("github-theme").setup({
      theme_style = "dark_default",
      -- other config
    })
  end,
}
