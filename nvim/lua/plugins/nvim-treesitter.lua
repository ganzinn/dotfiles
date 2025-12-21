return {
  -- シンタックスハイライト強化
  "nvim-treesitter/nvim-treesitter",
  event = { 'BufNewFile', 'BufRead' },
  build = ":TSUpdate",
  config = function ()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ensure_installed = {
        "markdown",
        "lua",
        "ruby",
        "tsx",
        "typescript",
      },
      sync_install = false,
      auto_install = true,
    })
  end
 }
