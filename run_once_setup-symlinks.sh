#!/bin/sh

CHEZMOI_CONFIG_DIR="$HOME/.local/share/chezmoi/dot_config"
CONFIG_DIR="$HOME/.config"

# NOTE: dot_config内にあるフォルダだけ書く
APPS=(
		"nvim"
		"wezterm"
		"fish"
		"gh"
		"zsh"
		"oh-my-posh"
)

for app in "${APPS[@]}"; do
    echo "Setting up symlink for $app..."
    
    # 実体があるか確認（Neovimなどで設定ミスを防ぐため）
    if [ -d "$CHEZMOI_CONFIG_DIR/$app" ]; then
        rm -rf "$CONFIG_DIR/$app"
        ln -s "$CHEZMOI_CONFIG_DIR/$app" "$CONFIG_DIR/$app"
    else
        echo "Error: Not found $CHEZMOI_CONFIG_DIR/$app"
    fi
done
