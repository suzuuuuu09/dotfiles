#!/usr/bin/env bash
# Neovim plugin restoration script (Lazy.nvim is auto-installed by Lua config)
# Restore plugins for the active Neovim configuration.

set -euo pipefail

if [[ $# -ne 0 ]]; then
  printf 'Usage: %s\n' "$0" >&2
  exit 2
fi

echo "📦 Restoring Neovim plugins from lazy-lock.json..."
nvim --headless "+Lazy! restore" +qa
echo "✅ Neovim plugins restored!"
