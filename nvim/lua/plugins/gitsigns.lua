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

-- [MONKEY-PATCH] neo-tree の git.status() キャッシュバグ回避
-- git/init.lua の raw_status_text_cache ヒット時に git_status_over_base（3番目の戻り値）が
-- 返されず、worktree.status_diff にも格納されないバグを補完する。
-- neo-tree 側で修正されたらこの patch は削除すること。
-- 関連: https://github.com/nvim-neo-tree/neo-tree.nvim のキャッシュ処理 (git/init.lua)
local neo_tree_patched = false
local function patch_neo_tree_git_status()
  if neo_tree_patched then return end
  local ok, neo_git = pcall(require, 'neo-tree.git')
  if not ok then return end
  local original_status = neo_git.status -- [MONKEY-PATCH] オリジナルを退避
  neo_git.status = function(path, base_lookup, skip_bubbling, status_opts)
    local status, worktree_root, over_base = original_status(path, base_lookup, skip_bubbling, status_opts)
    -- [MONKEY-PATCH] キャッシュヒットで over_base が欠落している場合に補完
    if status and worktree_root and not over_base and base_lookup and base_lookup[worktree_root] then
      local diff_ok, diff = pcall(require, 'neo-tree.git.diff')
      if diff_ok then
        local base = base_lookup[worktree_root]
        over_base = diff.diff_name_status(worktree_root, base, not not skip_bubbling)
        -- [MONKEY-PATCH] レンダラー用に worktree.status_diff にも格納
        local wt = neo_git.worktrees[worktree_root]
        if over_base and wt then
          wt.status_diff[base] = over_base
        end
      end
    end
    return status, worktree_root, over_base
  end
  neo_tree_patched = true
end

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
        patch_neo_tree_git_status()
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
