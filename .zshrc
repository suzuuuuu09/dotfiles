# OhMyPoshの設定
eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/nord-detailed.omp.json)"

# パスの設定
source "$ZSHDIR/path.zsh"
source "$ZSHDIR/alias.zsh"
