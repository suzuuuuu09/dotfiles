# Copilot Instructions

## Overview

This is a [chezmoi](https://www.chezmoi.io/) dotfiles repository. Chezmoi manages dotfiles by storing them in a source directory (`~/.local/share/chezmoi`) and applying them to `$HOME`. Files use chezmoi naming conventions (e.g., `dot_config/` → `~/.config/`).

## Architecture

### Chezmoi configuration

- **Mode**: Symlink mode on Linux/macOS (`.chezmoi.toml.tmpl`)
- **Symlink setup**: `run_once_setup-symlinks.sh` creates symlinks from `~/.config/<app>` → the chezmoi source directory for: nvim, fish, gh, zsh, oh-my-posh (wezterm is commented out — it uses chezmoi's built-in symlink mode instead)
- **File naming**: `dot_` prefix maps to `.`, `private_` prefix sets restrictive permissions, `empty_dot_` creates empty dotfiles

### Neovim (`dot_config/nvim/`)

The largest configuration. Uses **lazy.nvim** as the plugin manager.

- **Entry point**: `init.lua` → loads `config.lazy` (bootstraps lazy.nvim, sets leader to `<Space>`) then `config/` modules
- **Config modules** (`lua/config/`): `keymap.lua`, `options.lua`, `autocmd.lua`, `command.lua`
- **Plugin structure** (`lua/plugins/`): Organized by category via subdirectories (ui, lsp, cmp, coding, etc.). `plugins/init.lua` imports all subdirectories. Each plugin file returns a lazy.nvim spec (`LazyPluginSpec`).
- **LSP setup**: Mason auto-installs LSP servers. `lsp-config.lua` registers servers via `vim.lsp.config[]` / `vim.lsp.enable()` (Neovim 0.11+ API). Per-server overrides go in `lsp/settings/<server>.lua`. Completion capabilities come from blink.cmp.
- **Formatting**: conform.nvim handles formatting on save. When a conform formatter exists for a filetype, LSP formatting is disabled for that buffer.
- **Shared utilities**: `lua/user/icons.lua` for icon definitions
- **LSP server-specific config** (`lsp/` at nvim root): `lua_ls.lua`, `jsonls.lua`, `ruff.lua` — these are loaded by the native `vim.lsp.config` mechanism

### WezTerm (`dot_config/wezterm/`)

- `wezterm.lua`: Main config — terminal appearance, font (UDEV Gothic 35NF), Nord color scheme, custom tab styling
- `nord.lua`: Typed Nord palette module (`Nord.Palette`) used by both `wezterm.lua` and tab formatting. Reference color names via semantic groups: `polar_night`, `snow_storm`, `frost`, `aurora`
- `keybinds.lua`: Key bindings with leader key `Ctrl+i`

### Fish shell (`dot_config/fish/`)

- `config.fish` loads files from `config/`, `functions/`, and `tool_setup.fish`
- `tool_setup.fish`: Initializes oh-my-posh (Nord theme) and zoxide

## Key Conventions

- **Nord color theme** is used consistently across Neovim, WezTerm, fish, and oh-my-posh
- **Lua type annotations**: LuaCATS `---@type`, `---@class`, `---@module` annotations are used throughout (see `nord.lua`, conform config, etc.)
- **Japanese comments**: Inline comments are written in Japanese
- **Plugin specs**: Each Neovim plugin file returns a single `LazyPluginSpec` or `LazyPluginSpec[]` table — keep this pattern when adding plugins
- **Indentation**: 2-space tabs for Lua files (`shiftwidth=2`, `tabstop=2`)
