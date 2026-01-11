-- statuscolumn設定（LSP診断 + gitsigns + fold + 行番号）
return {
  "luukvbaal/statuscol.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local builtin = require("statuscol.builtin")

    -- 閉じたfoldがあるかチェックし、あればフラグを立てる
    local function should_show_fold(bufnr)
      -- 既にフラグが立っていれば表示
      if vim.b[bufnr].fold_column_shown then
        return true
      end
      -- 閉じたfoldがあるかチェック
      local has_closed = false
      vim.api.nvim_buf_call(bufnr, function()
        for lnum = 1, vim.fn.line("$") do
          if vim.fn.foldclosed(lnum) ~= -1 then
            has_closed = true
            break
          end
        end
      end)
      -- 閉じたfoldがあればフラグを立てる
      if has_closed then
        vim.b[bufnr].fold_column_shown = true
      end
      return has_closed
    end

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
        -- fold（一度閉じたら列を維持）
        {
          text = { builtin.foldfunc },
          click = "v:lua.ScFa",
          condition = {
            function(args)
              return should_show_fold(args.buf)
            end,
          },
        },
        -- 行番号
        { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
      },
    })
  end,
}
