local keymap = vim.keymap

vim.g.mapleader = " "

-- 挿入モードでのカーソル移動
keymap.set('i', '<C-j>', '<Down>')
keymap.set('i', '<C-k>', '<Up>')
keymap.set('i', '<C-h>', '<Left>')
keymap.set('i', '<C-l>', '<Right>')

-- バッファー移動
keymap.set('n', '<leader>bn', '<cmd>bnext<cr>', { desc = '次のバッファー' })
keymap.set('n', '<leader>bp', '<cmd>bprev<cr>', { desc = '前のバッファー' })

-- 画面分割
keymap.set('n', '<C-w>\\', '<cmd>vsplit<Return><C-w>w')
keymap.set('n', '<C-w>-', '<cmd>split<Return><C-w>w')

-- アクティブウィンドウの移動
-- keymap.set('n', '<leader>h', '<C-w>h')
-- keymap.set('n', '<leader>k', '<C-w>k')
-- keymap.set('n', '<leader>j', '<C-w>j')
-- keymap.set('n', '<leader>l', '<C-w>l')

-- 検索ハイライト解除
keymap.set('n', '<Esc>', '<cmd>nohlsearch<cr>', { desc = '検索ハイライト解除' })

-- ファイルパスをコピー
keymap.set('n', '<leader>cp', function()
  vim.fn.setreg('+', vim.fn.expand('%:.'))
  print('Copied: ' .. vim.fn.expand('%:.'))
end, { desc = '相対パスをコピー' })

keymap.set('n', '<leader>cP', function()
  vim.fn.setreg('+', vim.fn.expand('%:p'))
  print('Copied: ' .. vim.fn.expand('%:p'))
end, { desc = 'フルパスをコピー' })

-- 折り返し表示の切替
keymap.set('n', '<leader>w', function()
  vim.wo.wrap = not vim.wo.wrap
  print('wrap: ' .. (vim.wo.wrap and 'ON' or 'OFF'))
end, { desc = '折り返し切替' })
