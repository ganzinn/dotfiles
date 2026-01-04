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
        -- クリップボードをクリアして前の値が使われるのを防ぐ
        vim.fn.setreg("+", "")
        vim.cmd("GitBlameCopyPRURL")

        local attempts = 0
        local max_attempts = 30 -- 最大3秒待機

        local function check_and_open()
          attempts = attempts + 1
          local url = vim.fn.getreg("+")

          if url and url ~= "" then
            vim.fn.system({ "open", url })
          elseif attempts < max_attempts then
            vim.defer_fn(check_and_open, 100)
          else
            vim.notify("PR URLの取得がタイムアウトしました", vim.log.levels.WARN)
          end
        end

        vim.defer_fn(check_and_open, 100)
      end,
      desc = "PRをブラウザで開く",
    },
  },
}
