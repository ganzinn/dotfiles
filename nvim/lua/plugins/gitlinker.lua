return {
  -- GitHubのWebページでファイルを開く
  "ruifm/gitlinker.nvim",
  dependencies = "nvim-lua/plenary.nvim",
  opts = {
    opts = {
      add_current_line_on_normal_mode = false,  -- ノーマルモードで行数を含めない
    },
  },
  keys = {
    { "<leader>gl", function() require("gitlinker").get_buf_range_url("n") end, mode = "n", desc = "GitHubリンクをコピー" },
    { "<leader>gl", function() require("gitlinker").get_buf_range_url("v") end, mode = "v", desc = "GitHubリンクをコピー（選択範囲）" },
    { "<leader>gL", function() require("gitlinker").get_buf_range_url("n", { action_callback = require("gitlinker.actions").open_in_browser }) end, mode = "n", desc = "GitHubで開く" },
    { "<leader>gL", function() require("gitlinker").get_buf_range_url("v", { action_callback = require("gitlinker.actions").open_in_browser }) end, mode = "v", desc = "GitHubで開く（選択範囲）" },
  },
}
