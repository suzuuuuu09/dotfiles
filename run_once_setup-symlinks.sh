#!/bin/sh

CHEZMOI_SOURCE="$HOME/.local/share/chezmoi"
CONFIG_DIR="$HOME/.config"
APPS="nvim wezterm fish"

for app in $APPS; do
	  echo "Setting up symlink for $app..."
    rm -rf "$CONFIG_DIR/$app"
    ln -s "$CHEZMOI_SOURCE/dot_config/$app" "$CONFIG_DIR/$app"
done
