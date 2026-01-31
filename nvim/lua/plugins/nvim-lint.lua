-- Linter（ESLint等）
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      javascript = { "eslint" },
      typescript = { "eslint" },
      javascriptreact = { "eslint" },
      typescriptreact = { "eslint" },
      ruby = { "rubocop" },
    }

    -- rubocop を bundle exec 経由で実行
    lint.linters.rubocop.cmd = "bundle"
    lint.linters.rubocop.args = { "exec", "rubocop", "--format", "json", "--force-exclusion" }

    -- ファイル保存時とファイル読み込み時にlintを実行
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
