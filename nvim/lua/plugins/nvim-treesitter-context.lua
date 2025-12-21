return {
  -- 現在のコンテキストを上部に固定表示
  "nvim-treesitter/nvim-treesitter-context",
  dependencies = {"nvim-treesitter/nvim-treesitter"},
  config = function()
    require("treesitter-context").setup()
  end
}
