return {
  -- コメントのトグル
  'JoosepAlviste/nvim-ts-context-commentstring',
  dependencies = {
    'numToStr/Comment.nvim'
  },
  config = function()
    require('ts_context_commentstring').setup({
      enable_autocmd = false,
    })
    require('Comment').setup({
      toggler = { line = "<C-/>" },
      opleader = { line = "<C-/>" },
      pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
    })
  end,
  -- keys = {
  --   { mode = "n", "<C-/>","<cmd>gcc<cr>",{ desc = "コメントアウト" }, },
  -- },
}
