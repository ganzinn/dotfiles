return {
  -- Git差分ビューア
  'sindrets/diffview.nvim',
  keys = {
    {
      '<leader>gD',
      function()
        local lib = require('diffview.lib')
        local view = lib.get_current_view()
        if view then
          vim.cmd('DiffviewClose')
        else
          local base = vim.g.gitsigns_base or 'HEAD'
          if base == 'HEAD' then
            vim.cmd('DiffviewOpen')
          else
            vim.cmd('DiffviewOpen ' .. base)
          end
        end
      end,
      desc = 'Diffviewをトグル（gitsigns_baseに連動）',
    },
  },
  opts = {
    default_args = {
      DiffviewOpen = { "--imply-local" },
    },
    hooks = {
      diff_buf_win_enter = function(bufnr, winid, ctx)
        -- 行の折り返しを無効化（左右パネルの行ずれを防止）
        vim.wo[winid].wrap = false

        -- フィラー行を斜線パターンで表示
        vim.opt_local.fillchars:append { diff = "╱" }

        -- フィラー行（斜線）の背景を透明に
        vim.api.nvim_set_hl(0, "DiffDelete", { bg = "none", fg = "#3e4452" })
        vim.api.nvim_set_hl(0, "DiffviewDiffDelete", { bg = "none", fg = "#3e4452" })

        -- 左パネルの削除行・削除単語を赤系背景で表示
        if ctx.symbol == "a" then
          vim.api.nvim_set_hl(0, "DiffviewDiffAddAsDelete", { bg = "#3d2021" })
          vim.api.nvim_set_hl(0, "DiffviewDiffTextDelete", { bg = "#4d2021" })
          vim.wo[winid].winhl = "DiffAdd:DiffviewDiffAddAsDelete,DiffDelete:DiffviewDiffDelete,DiffText:DiffviewDiffTextDelete"
        end
      end,
    },
  },
}
