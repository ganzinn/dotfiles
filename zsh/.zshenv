# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# mise
eval "$(mise activate zsh --shims)"

# PC固有の設定（.zshrc.local）があれば読み込む
if [ -f "$HOME/.zshenv.local" ]; then
    source "$HOME/.zshenv.local"
fi
