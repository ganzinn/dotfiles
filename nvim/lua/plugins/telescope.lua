return {
  -- ファジーファインダー
  "nvim-telescope/telescope.nvim", tag = "0.1.8",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    {
      "nvim-telescope/telescope-frecency.nvim",
      version = "*",
    },
    {
      "nvim-telescope/telescope-file-browser.nvim",
    },
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
    },
  },
  keys = {
    {mode = "n", "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Telescopeでファイル検索"},
    {mode = "n", "<C-g>", function()
      require("telescope").extensions.live_grep_args.live_grep_args()
    end, desc = "Telescopeで行検索（引数指定可）"},
  },
  config = function()
    require("telescope").setup({
      defaults = {
        file_ignore_patterns = {
          -- 検索から除外するものを指定
          "^.git/",
          "^.cache/",
          -- "^node_modules/",
          -- "^vendor/bundle/",
          -- "^storage/",
        },
        vimgrep_arguments = {
          -- grep_string, live_grep に適用される
          -- ripggrepコマンドのオプション
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
        },
      },
      pickers = {
        find_files = {
          find_command = { "rg", "--files", "--color", "never", "-g", "!.git" },
          hidden = true,
          -- no_ignore = true,
        },
      },
      extensions = {
        -- ソート性能を大幅に向上させるfzfを使う
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        file_browser = {
          theme = "ivy",
           -- disables netrw and use telescope-file-browser in its place
          hijack_netrw = true,
          mappings = {},
        },
        live_grep_args = {
          auto_quoting = true,
        },
      },
    })
    require("telescope").load_extension("fzf")
    require("telescope").load_extension("frecency")
    require("telescope").load_extension("file_browser")
    require("telescope").load_extension("live_grep_args")
  end
}
