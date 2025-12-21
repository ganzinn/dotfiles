return {
  -- ファイルエクスプローラー
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
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
    close_if_last_window = true,
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false,
        hide_by_name = {
          --"node_modules"
        },
        hide_by_pattern = { -- uses glob style patterns
          "*/.git",
          --"*.meta",
          --"*/src/*/tsconfig.json",
        },
      },
      follow_current_file = {
        enabled = true,  -- This will find and focus the file in the active buffer every time
        --               -- the current file is changed while the tree is open.
        leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
      },
    },
  },
  keys = {
    { mode = "n", "<C-e>", "<cmd>Neotree toggle action=show<cr>", { desc = "neo-treeの開閉" } },
  }
}
