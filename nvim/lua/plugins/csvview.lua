-- CSVをテーブル形式で整形表示
return {
  "hat0uma/csvview.nvim",
  ft = { "csv" },
  opts = {
    view = {
      display_mode = "border",  -- 罫線付き表示
    },
  },
  keys = {
    { "<leader>mp", "<cmd>CsvViewToggle<cr>", ft = "csv", desc = "CSVプレビュー切替" },
  },
}
