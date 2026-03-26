# Homebrew
set -x PATH /opt/homebrew/bin $PATH

# VSCode
fish_add_path /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin

# Node.js / npm / nvm
set -x NVM_DIR $HOME/.nvm
fish_add_path $HOME/.nodebrew/current/bin

# go
fish_add_path $HOME/go/bin

# pyenv / Python
set -x PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/shims

# Cursor Agent
fish_add_path $HOME/.local/bin

# bun
fish_add_path $HOME/.bun/bin

# Obsidian
fish_add_path /Applications/Obsidian.app/Contents/MacOS

# Nix darwin
fish_add_path /run/current-system/sw/bin

# Rust
fish_add_path $HOME/.cargo/bin

# mise
fish_add_path $HOME/.mise/bin
