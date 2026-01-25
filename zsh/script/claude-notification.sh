#!/bin/bash
# ~/.claude/settings.json のhooks(Notification, Stop)に本scriptを指定

# stdin から JSON を読み取り
INPUT=$(cat)

TYPE=$(echo "$INPUT" | jq -r '.notification_type // .hook_event_name // "unknown"')
CWD=$(echo "$INPUT" | jq -r '.cwd // ""')
MESSAGE=$(echo "$INPUT" | jq -r '.message // ""')

# idle_prompt は通知しない
if [ "$TYPE" = "idle_prompt" ]; then
  exit 0
fi

# 通知メッセージを設定（message フィールドがあればそれを使用）
if [ -n "$MESSAGE" ]; then
  MSG="$MESSAGE"
else
  case "$TYPE" in
    permission_prompt) MSG="許可が必要です" ;;
    tool_permission_prompt) MSG="ツール実行の許可が必要です" ;;
    user_question_prompt) MSG="質問があります" ;;
    Stop) MSG="タスクが完了しました" ;;
    *) MSG="通知" ;;
  esac
fi

# 通知クリック時のコマンドを構築
FOCUS_CMD='osascript -e "tell application \"WezTerm\" to activate"'
[ -n "$WEZTERM_PANE" ] && FOCUS_CMD="$FOCUS_CMD; /opt/homebrew/bin/wezterm cli activate-pane --pane-id $WEZTERM_PANE 2>/dev/null"

# 通知を送信
terminal-notifier \
  -title "Claude Code" \
  -subtitle "${CWD##*/}" \
  -message "$MSG" \
  -sound Hero \
  -group "claudecode" \
  -execute "bash -c '$FOCUS_CMD'"

exit 0
