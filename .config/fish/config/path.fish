switch (uname)
    case Darwin
        # Homebrew
        fish_add_path /opt/homebrew/bin

        # VSCode
        fish_add_path /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin

        # Obsidian
        fish_add_path /Applications/Obsidian.app/Contents/MacOS
    case Linux
        # Windows integration for NixOS-WSL
        fish_add_path /mnt/c/Windows/System32
end

# Nix system binaries
fish_add_path /run/current-system/sw/bin

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

# Rust
fish_add_path $HOME/.cargo/bin

# mise
fish_add_path $HOME/.mise/bin
