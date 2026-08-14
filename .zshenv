export ZSHDIR=$HOME/.config/zsh
export NVM_DIR=$HOME/.nvm
export XDG_CONFIG_HOME=${HOME}/.config

if [[ -r "$HOME/.cargo/env" ]]; then
  . "$HOME/.cargo/env"
fi
