return {
  -- インデントガイドとチャンク表示
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("hlchunk").setup({
      chunk = {
        enable = true,
        style = {
          { fg = "#00ffff" },
          { fg = "#c21f30" },
        },
        delay = 0,
      },
      indent = {
        enable = true,
        chars = { "▏" },
      },
      --line_num = {
      --  enable = true,
      --},
      -- blank = {
      --   enable = true,
      --   chars = {
      --     "  ",
      --   },
      --   style = {
      --     { bg = "#434437" },
      --     { bg = "#2f4440" },
      --     { bg = "#433054" },
      --     { bg = "#284251" },
      --   },
      -- },
    })
  end
}
