-- リモートを取得（upstream優先、なければorigin）
local function get_remote()
  local result = vim.fn.system('git remote 2>/dev/null')
  if result:match('upstream') then
    return 'upstream'
  end
  return 'origin'
end

-- デフォルトブランチを取得
local function get_default_branch()
  local remote = get_remote()
  local result = vim.fn.system('git symbolic-ref refs/remotes/' .. remote .. '/HEAD 2>/dev/null')
  if vim.v.shell_error == 0 then
    return result:match('refs/remotes/' .. remote .. '/(.+)'):gsub('%s+', '')
  end
  return 'main'
end

-- マージベース（分岐点）を取得
local function get_merge_base()
  local remote = get_remote()
  local default_branch = get_default_branch()
  local result = vim.fn.system('git merge-base HEAD ' .. remote .. '/' .. default_branch .. ' 2>/dev/null')
  if vim.v.shell_error == 0 then
    return result:gsub('%s+', '')
  end
  return nil
end

-- トグル状態を保持
local base_is_merge_base = false
vim.g.gitsigns_base = 'HEAD'

return {
  -- Git変更箇所の表示
  'lewis6991/gitsigns.nvim',
  opts = {
    max_file_length = 100000,
    preview_config = {
      border = 'rounded',
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1,
    },
  },
  keys = {
    -- マージベース/HEADの差分表示をトグル
    {
      '<leader>gm',
      function()
        local gitsigns = require('gitsigns')
        local current_win = vim.api.nvim_get_current_win()
        if base_is_merge_base then
          gitsigns.reset_base(true)
          base_is_merge_base = false
          vim.g.gitsigns_base = 'HEAD'
          local source = vim.g.neo_tree_source or 'filesystem'
          vim.cmd('Neotree ' .. source .. ' git_base=HEAD')
          print('gitsigns: base reset to HEAD')
        else
          local merge_base = get_merge_base()
          if merge_base then
            gitsigns.change_base(merge_base, true)
            base_is_merge_base = true
            vim.g.gitsigns_base = merge_base
            local source = vim.g.neo_tree_source or 'filesystem'
            vim.cmd('Neotree ' .. source .. ' git_base=' .. merge_base)
            print('gitsigns: base changed to merge-base')
          else
            print('gitsigns: merge-base not found')
          end
        end
        vim.api.nvim_set_current_win(current_win)
      end,
      desc = 'マージベース/HEADの差分表示をトグル',
    },
    -- 変更箇所をプレビュー
    {
      '<leader>gd',
      function()
        require('gitsigns').preview_hunk()
      end,
      desc = '変更箇所をプレビュー',
    },
  },
}
