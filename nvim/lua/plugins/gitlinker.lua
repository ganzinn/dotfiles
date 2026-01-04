return {
  -- GitHubのWebページでファイルを開く
  "ruifm/gitlinker.nvim",
  dependencies = "nvim-lua/plenary.nvim",
  opts = {},
  keys = {
    { "n", "<leader>gl", function() require("gitlinker").get_buf_range_url("n") end, desc = "GitHubリンクをコピー" },
    { "v", "<leader>gl", function() require("gitlinker").get_buf_range_url("v") end, desc = "GitHubリンクをコピー（選択範囲）" },
    { "n", "<leader>gL", function() require("gitlinker").get_buf_range_url("n", { action_callback = require("gitlinker.actions").open_in_browser }) end, desc = "GitHubで開く" },
    { "v", "<leader>gL", function() require("gitlinker").get_buf_range_url("v", { action_callback = require("gitlinker.actions").open_in_browser }) end, desc = "GitHubで開く（選択範囲）" },
  },
}
