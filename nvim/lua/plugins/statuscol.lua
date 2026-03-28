-- statuscolumn設定（LSP診断 + gitsigns + fold + 行番号）
return {
  "luukvbaal/statuscol.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local builtin = require("statuscol.builtin")

    require("statuscol").setup({
      relculright = true,
      ft_ignore = { "neo-tree", "toggleterm", "help", "lazy" },
      segments = {
        -- LSP診断サイン
        { sign = { namespace = { "diagnostic" }, maxwidth = 1, auto = true },
          click = "v:lua.ScSa" },
        -- gitsigns
        { sign = { namespace = { "gitsigns" }, maxwidth = 1, colwidth = 1, auto = true },
          click = "v:lua.ScSa" },
        -- fold
        {
          text = { builtin.foldfunc },
          click = "v:lua.ScFa",
        },
        -- 行番号
        { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
      },
    })
  end,
}
