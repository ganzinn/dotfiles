-- Claude AI連携
return {
  "coder/claudecode.nvim",
  lazy = false,
  dependencies = {
    "folke/snacks.nvim",
  },
  opts = {
    terminal = {
      snacks_win_opts = {
        position = "right",
        width = 0.40,  -- 画面幅の40%
        wo = {
          winhighlight = "Normal:Normal,NormalFloat:Normal",
        },
      },
    },
  },
  keys = {
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
  },
  config = function(_, opts)
    require("claudecode").setup(opts)

    -- VimResizedイベントでClaude Codeウィンドウをリサイズ
    local claude_width_ratio = 0.40
    vim.api.nvim_create_autocmd("VimResized", {
      group = vim.api.nvim_create_augroup("ClaudeCodeResize", { clear = true }),
      callback = function()
        -- Claude Code用のターミナルウィンドウを探してリサイズ
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local bufname = vim.api.nvim_buf_get_name(buf)
          -- Claude Codeのターミナルバッファを検出
          if bufname:match("claude") or vim.bo[buf].filetype == "snacks_terminal" then
            local new_width = math.floor(vim.o.columns * claude_width_ratio)
            vim.api.nvim_win_set_width(win, new_width)
          end
        end
      end,
    })
  end,
}
