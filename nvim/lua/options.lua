-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local opt = vim.opt

-- opt.helplang = 'ja'
-- クリップボード連携
opt.clipboard:append({'unnamedplus'})

-- 文字
vim.scriptencoding = "utf-8"
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

-- 不可視文字可視化
opt.listchars = { tab='»-', trail='-', eol='↲', extends='»', precedes='«', nbsp='␣' }
opt.list = true

opt.number = true  -- 行番号を表示する
opt.cursorline = true
opt.termguicolors = true

-- タブとインデントの設定
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.smartindent = true

-- 折りたたみ設定
opt.foldmethod = "indent"
opt.foldlevel = 99 -- デフォルトで開くため設定

opt.hidden = true
opt.swapfile = false -- swapfileを作成しないように設定
opt.backup = false
opt.mouse = 'a' --マウス操作を有効化

-- 外部変更時のバッファ自動更新
opt.autoread = true
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('AutoRefresh', { clear = true }),
  command = 'checktime'
})
