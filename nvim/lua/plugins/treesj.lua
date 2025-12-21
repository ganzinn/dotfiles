return {
  -- コードブロックの分割/結合
  'Wansmer/treesj',
  dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`

  keys = { '<space>m', },
  config = function()
    require('treesj').setup({--[[ your config ]]})
  end,
}
