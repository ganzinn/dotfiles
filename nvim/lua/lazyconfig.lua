-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- 他のプラグインで共通に使う系（lazy = true で必要になったら呼び出し） 
    { "nvim-tree/nvim-web-devicons",  lazy = true },

    -- 個別
    { import = "plugins.toggleterm" },
    { import = "plugins.which-key" },
    { import = "plugins.barbar" },
    { import = "plugins.lualine" },
    -- { import = "plugins.nvim-tree" },
    { import = "plugins.neo-tree" },
    { import = "plugins.catppuccin" },
    { import = "plugins.nvim-treesitter" },
    { import = "plugins.nvim-treesitter-context" },
    { import = "plugins.telescope" },
    -- { import = "plugins.indent" },
    { import = "plugins.hlchunk" },
    { import = "plugins.gitsigns" },
    { import = "plugins.comment" },
    { import = "plugins.treesj" },
    { import = "plugins.close-buffers" },
    { import = "plugins.diffview" },
    { import = "plugins.nvim-highlight-colors" },
    { import = "plugins.nvim-scrollbar" },
    { import = "plugins.nvim-surround" },
    { import = "plugins.vimdoc-ja" },
    { import = "plugins.im-select" },
    { import = "plugins.claudecode" },
    -- { import = "plugins" }, -- ディレクトリまとめて読み込む

    -- LSP関連
    { import = "plugins.lsp" }, -- ディレクトリまとめて読み込む
    -- require("plugins.lsp")
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },

  -- プラグインの自動更新を有効化
  checker = { enabled = false },
})

