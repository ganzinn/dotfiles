# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# mise
eval "$(mise activate zsh --shims)"

# PC固有の設定があれば読み込む
if [ -f "$ZDOTDIR/.zprofile.local" ]; then
    source "$ZDOTDIR/.zprofile.local"
fi
