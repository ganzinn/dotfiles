-- Git Blame表示とPR確認
return {
  "f-person/git-blame.nvim",
  event = "VeryLazy",
  opts = {
    enabled = false, -- 起動時は無効（トグルで切り替え）
    date_format = "%Y-%m-%d",
    message_when_not_committed = "Not Committed Yet",
  },
  keys = {
    { "<leader>gb", "<cmd>GitBlameToggle<cr>", desc = "Git Blame トグル" },
    { "<leader>gp", "<cmd>GitBlameCopyPRURL<cr>", desc = "PR URLをコピー" },
    {
      "<leader>gP",
      function()
        vim.cmd("GitBlameCopyPRURL")
        vim.defer_fn(function()
          local url = vim.fn.getreg("+")
          if url and url ~= "" then
            vim.fn.system({ "open", url })
          end
        end, 100)
      end,
      desc = "PRをブラウザで開く",
    },
  },
}
