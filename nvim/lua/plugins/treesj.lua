return {
  -- コードブロックの分割/結合
  'Wansmer/treesj',
  dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`

  keys = {
    { '<leader>sj', '<cmd>TSJToggle<cr>', desc = 'コードブロックの分割/結合' },
  },
  config = function()
    require('treesj').setup({
      use_default_keymaps = false,
    })
  end,
}
