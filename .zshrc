export OH_MY_POSH_THEME="nord-detailed"

# OhMyPosh Setup
eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/themes/${OH_MY_POSH_THEME}.omp.json)"

# zoxide Setup
eval "$(zoxide init zsh)"

# mise Setup
eval "$(mise activate zsh)"

eval "$(/usr/libexec/path_helper)"

export PATH="$HOME/.bun/bin:$PATH"

# zsh-autosuggestionsとzsh-syntax-highlightingの設定
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Enable complementary features
# autoload -U compinit
# compinit
if typebrew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  source $(brew --predix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  autoload -U +X compinit && compinit
fi

# Fill the selected part of the completion list
zstyle ':completion:*' menu select

# 間違ったコマンドを補正する
setopt correct

# 同じコマンドを履歴に保存しない
setopt hist_ignore_dups

autoload -Uz colors && colors

# ┌───────────────┐
#   Path Settings 
# └───────────────┘
source "$ZSHDIR/path.zsh"

# ┌──────────────────┐
#   Aliases Settings 
# └──────────────────┘
source "$ZSHDIR/alias.zsh"


### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zdharma/history-search-multi-word

# bun completions
[ -s "/Users/k25012kk/.bun/_bun" ] && source "/Users/k25012kk/.bun/_bun"

# ghq
function ghq-fzf() {
  local src=$(ghq list | fzf --preview "bat --color=always --style=header,grid --line-range :80 $(ghq root)/{}/README.*")
  if [ -n "$src" ]; then
    BUFFER="cd $(ghq root)/$src"
    zle accept-line
  fi
  zle -R -c
}
zle -N ghq-fzf
bindkey '^g' ghq-fzf

