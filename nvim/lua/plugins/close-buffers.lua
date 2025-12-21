return {
  -- バッファを一括削除
  'kazhala/close-buffers.nvim',
  config = function()
    vim.keymap.set(
      'n',
      '<leader>ta',
      '<CMD>lua require("close_buffers").delete({type = "hidden"})<CR>',
      { noremap = true, silent = true }
    )
    vim.keymap.set(
      'n',
      '<leader>tc',
      '<CMD>lua require("close_buffers").delete({type = "this"})<CR>',
      { noremap = true, silent = true }
    )
  end,
}
