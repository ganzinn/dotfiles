-- local lsp_server = {
--   "lua_ls",
--   "ts_ls",
--   "pyright",
--   "ruby-lsp",
-- }

return {
  -- LSP設定
  "neovim/nvim-lspconfig",
  -- event = { "BufReadPost", "BufNewFile" },
  -- cmd = { "LspInfo", "LspInstall", "LspUninstall" },
  dependencies = {
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup({
      handlers = {
        function(server_name)
          require("lspconfig")[server_name].setup({})
        end,
      },
    })
  end,

}

