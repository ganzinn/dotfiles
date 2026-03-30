-- Linter（ESLint等）
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      javascript = { "eslint", "biomejs" },
      typescript = { "eslint", "biomejs" },
      javascriptreact = { "eslint", "biomejs" },
      typescriptreact = { "eslint", "biomejs" },
      ruby = { "rubocop" },
    }

    -- rubocop を bundle exec 経由で実行
    lint.linters.rubocop.cmd = "bundle"
    lint.linters.rubocop.args = { "exec", "rubocop", "--format", "json", "--force-exclusion" }

    -- ファイル保存時とファイル読み込み時にlintを実行（コマンドが存在するlinterのみ）
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      callback = function()
        local ft = vim.bo.filetype
        local names = lint.linters_by_ft[ft] or {}
        local available = {}
        for _, name in ipairs(names) do
          local linter = lint.linters[name]
          local cmd = linter and linter.cmd
          if type(cmd) == "function" then
            cmd = cmd()
          end
          if cmd and vim.fn.executable(cmd) == 1 then
            table.insert(available, name)
          end
        end
        if #available > 0 then
          lint.try_lint(available)
        end
      end,
    })
  end,
}
