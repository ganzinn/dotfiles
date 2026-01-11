return {
  -- カラースキーム
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  opts = {
    transparent_background = true,
    custom_highlights = {
      NormalFloat = { bg = "NONE" },
      TelescopeBorder = { bg = "NONE" },
      -- gitsigns preview_hunk用（行単位）
      GitSignsAddPreview = { fg = "#ffffff", bg = "#1d3d21" },
      GitSignsDeletePreview = { fg = "#ffffff", bg = "#3d2021" },
      -- gitsigns preview_hunk用（単語単位）
      GitSignsAddInline = { fg = "#ffffff", bg = "#2d7d31" },
      GitSignsDeleteInline = { fg = "#ffffff", bg = "#7d2525" },
      GitSignsChangeInline = { fg = "#ffffff", bg = "#3d4d51" },
    },
  },
}
