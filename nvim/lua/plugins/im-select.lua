-- 入力メソッド自動切り替え
return {
  "keaising/im-select.nvim",
  config = function()
    require("im_select").setup({
      default_im_select = "com.apple.keylayout.ABC",
      default_command = "macism",
      set_default_events = { "VimEnter", "InsertLeave", "FocusGained", "BufEnter", "TermLeave" },
      set_previous_events = {},
    })
  end,
}
