#!/bin/bash

# メインリポジトリかどうかを確認（サブディレクトリからの実行も許容）
repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
if [[ -z "$repo_root" ]]; then
  echo "Error: Not a git repository" >&2
  exit 1
fi
main_repo=$(git worktree list --porcelain | awk 'NR==1{print $2}')
if [[ "$repo_root" != "$main_repo" ]]; then
  echo "Error: Must be run from the main repository (not a worktree)" >&2
  exit 1
fi

# デフォルトブランチを取得（例: origin/main, origin/master）
DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/@@')
if [[ -z "$DEFAULT_BRANCH" ]]; then
  echo "Error: Could not determine default branch." >&2
  echo "Run: git remote set-head origin --auto" >&2
  exit 1
fi

echo "Default branch: $DEFAULT_BRANCH"
echo ""

repo_name=$(basename "$main_repo")

success=()
failed=()
skipped=()

# worktreeリストを解析（--porcelain形式）
# エントリは空行区切り、最初のエントリがメインリポジトリ
wt_path=""

# --porcelain の出力は末尾に空行がないため、最後のエントリを処理するために空行を補完
while IFS= read -r line; do
  if [[ "$line" == worktree\ * ]]; then
    wt_path="${line#worktree }"
  elif [[ -z "$line" ]]; then
    # エントリの終わり
    if [[ -n "$wt_path" && "$wt_path" != "$main_repo" ]]; then
      wt_name=$(basename "$wt_path")

      # 「リポジトリ名-数値」形式のworktreeのみ対象
      if [[ ! "$wt_name" =~ ^${repo_name}-[0-9]+$ ]]; then
        echo "Skipping (not target format): $wt_name"
        skipped+=("$wt_name (not target format)")
      # worktree名と同名のブランチが存在するか確認
      elif ! git branch --list "$wt_name" | grep -q .; then
        echo "Skipping (branch not found): $wt_name"
        skipped+=("$wt_name (branch not found)")
      else
        echo "Rebasing: $wt_name ($wt_path)"
        if git -C "$wt_path" rebase "$DEFAULT_BRANCH"; then
          success+=("$wt_name")
        else
          git -C "$wt_path" rebase --abort 2>/dev/null
          echo "  -> Failed. Aborted." >&2
          failed+=("$wt_name")
        fi
      fi
    fi
    wt_path=""
  fi
done < <(git worktree list --porcelain; echo "")

echo ""
echo "===== Result ====="
echo "Success (${#success[@]}): ${success[*]}"
if [[ ${#skipped[@]} -gt 0 ]]; then
  echo "Skipped (${#skipped[@]}): ${skipped[*]}"
fi
if [[ ${#failed[@]} -gt 0 ]]; then
  echo "Failed  (${#failed[@]}): ${failed[*]}" >&2
  exit 1
fi
