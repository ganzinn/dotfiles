return {
  -- ファイルエクスプローラー
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  keys = {{
    mode = "n",
    "<C-e>",
    function()
      local api = require("nvim-tree.api")
      api.tree.toggle({
        focus = false,
        find_file = true,
      })
    end,
    { desc = "nvim-treeの開閉"},
  }},
  opts = {
    view = {
      width = 40,
    },
    filters = {
      git_ignored = false, -- デフォルトはtrue
      custom = {
        "^\\.git$",
      },
    },
    renderer = {
      indent_markers = { enable = true },
    },
    git = {
      ignore = false,
    }
  },
}
