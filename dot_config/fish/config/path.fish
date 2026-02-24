# VSCode
set -x PATH $PATH /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin

# Node.js / npm / nvm
set -x PATH $HOME/.nodebrew/current/bin $PATH
set -x NVM_DIR $HOME/.nvm
set -x PATH /Users/k25012kk/.bun/bin $PATH

# go
set -x PATH $HOME/go/bin $PATH

# pyenv / Python
set -x PYENV_ROOT $HOME/.pyenv
set -x PATH $PYENV_ROOT/bin $PATH

# Cursor Agent
set -x PATH $HOME/.local/bin $PATH

# bun
set -x BUN_INSTALL $HOME/.bun
set -x PATH $BUN_INSTALL/bin $PATH

# Homebrew
set -x PATH /opt/homebrew/bin $PATH
