return {
  -- ステータスライン
  'nvim-lualine/lualine.nvim',
  opts = {
    options = {
      disabled_filetypes = { 'NvimTree', 'neo-tree' },
    },
    sections = {
      lualine_x = {
        {
          function()
            return ' merge-base'
          end,
          cond = function()
            return vim.g.gitsigns_base ~= 'HEAD'
          end,
          color = { fg = '#f9e2af' },
        },
        'encoding',
        'fileformat',
        'filetype',
      },
    },
  },
}
