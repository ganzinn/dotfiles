return {
  -- ファイルエクスプローラー
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    {"3rd/image.nvim", opts = {}},
  },
  opts = {
    default_component_configs = {
      git_status = {
        symbols = {
          unstaged = "",  -- 空文字で非表示
          staged = "",    -- 空文字で非表示
        },
      },
    },
    close_if_last_window = true, -- neo-tree以外のウィンドウがすべて閉じられた場合、neo-treeも自動で閉じてNeovimを終了
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,    -- ドットファイル（.gitignore等）を表示
        hide_gitignored = false,  -- .gitignoreで無視されたファイルを表示
        hide_hidden = false,      -- 隠しファイルを表示
        hide_by_name = {},
        hide_by_pattern = {
          "*/.git",  -- .gitディレクトリを非表示
        },
      },
      follow_current_file = {
        enabled = true,           -- バッファ切り替え時にツリー上のファイルを自動フォーカス
        leave_dirs_open = false,  -- 自動展開されたディレクトリは閉じる
      },
    },
  },
  keys = {
    { mode = "n", "<C-e>", "<cmd>Neotree toggle action=show<cr>", { desc = "neo-treeの開閉" } },
  }
}
