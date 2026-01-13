# Loading zsh plugins
eval "$(sheldon source)"

# mise設定
eval "$(mise activate zsh)"

# gh補完設定
eval "$(gh completion -s zsh)"

# zoxide設定
eval "$(zoxide init zsh)"

# 環境変数 ---------------------------------------------------------------------------------------
typeset -U path PATH
path=(
  $HOME/.local/bin(N-/)
  $path
)

# XDG Base Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

if [[ -f "$HOME/.zsh_secrets" ]]; then
    source "$HOME/.zsh_secrets"
fi

export GITHUB_TOKEN_FOR_GITHUB_PACKAGES=$GITHUB_TOKEN
export BUNDLE_RUBYGEMS__PKG__GITHUB__COM=$GITHUB_TOKEN
# GitHub.com (github.com) のプライベートリポジトリから直接gemをインストールする際に使用
export BUNDLE_GITHUB__COM=$GITHUB_USERNAME:$GITHUB_TOKEN

# https://blog.phusion.nl/2017/10/13/why-ruby-app-servers-break-on-macos-high-sierra-and-what-can-be-done-about-it/
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# gem設定（ローカル限定）
export BUNDLE_BUILD__MYSQL2=--with-ldflags="-L$(brew --prefix zstd)/lib"
export BUNDLE_BUILD__MECAB=--with-cppflags="-I$(brew --prefix mecab)/include"
export BUNDLE_BUILD__OX=--with-cflags=-Wno-implicit-function-declaration
export LDFLAGS="-L$(brew --prefix libffi)/lib"
export CPPFLAGS="-I$(brew --prefix libffi)/include"
export PKG_CONFIG_PATH="$(brew --prefix libffi)/lib/pkgconfig"

export LSCOLORS=exfxcxdxbxGxDxabagacad

# docker設定
export DOCKER_HOST="unix://$XDG_CONFIG_HOME/colima/default/docker.sock"

# history ----------------------------------------------------------------------------------------
HISTSIZE=100000
SAVEHIST=100000

# ------------------------------------------------------------------------------------------------
# fzf --------------------------------------------------------------------------------------------
eval "$(fzf --zsh)"
export FZF_DEFAULT_OPTS='--height 40% --reverse'

# リポジトリ移動
function cd_ghq_list() {
  local selected_dir=$(ghq list -p | fzf)
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
}
zle -N cd_ghq_list
bindkey "^]" cd_ghq_list

# ブランチ移動
function checkout-fzf-gitbranch() {
  local GIT_BRANCH=$(git branch --all | grep -v HEAD | fzf +m)
  if [ -n "$GIT_BRANCH" ]; then
    git checkout $(echo "$GIT_BRANCH" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
    zle accept-line
  fi
}
zle -N checkout-fzf-gitbranch
bindkey '^O' checkout-fzf-gitbranch

# ------------------------------------------------------------------------------------------------
# alias ------------------------------------------------------------------------------------------
alias cot='open $1 -a "/Applications/CotEditor.app"'
alias vi='nvim'
alias ls='ls --color'
alias l='ls'
alias la='ls -a'
alias ll='ls -la'
alias zshrc='vi ~/.zshrc'
alias unicode='ruby -e "p ARGV[0].codepoints.map{|c|c.to_s(16)}"'
alias tmp='cd ~/tmp'

# ------------------------------------------------------------------------------------------------

# PC固有の設定（.zshrc.local）があれば読み込む
if [ -f "$HOME/.zshrc.local" ]; then
    source "$HOME/.zshrc.local"
fi

export PATH

# starship 設定(最後に指定)
eval "$(starship init zsh)"
