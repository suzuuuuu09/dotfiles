# Repository Guidelines

## Project Structure & Module Organization
This repository stores macOS dotfiles and agent-related helpers.

- `.config/nix/`: nix-darwin and Home Manager modules, overlays, and secrets wiring.
- `.config/nvim/`: Neovim configuration, plugins, LSP setup, snippets, and `lazy-lock.json`.
- `.config/wezterm/`, `.config/fish/`, `.config/ghostty/`, `.config/yazi/`: per-app configuration.
- `skills/`: local Codex skills and scripts.
- `.github/`: CI workflows and repo automation.
- `scripts/`: standalone helper scripts such as `scripts/nvim-restore.sh`.

Keep changes in the smallest relevant module and preserve the existing split between system, user, and app-specific config.

## Build, Test, and Development Commands
This repo is validated through Nix and a few config-specific checks.

- `nix flake check`: evaluates the flake and runs available checks.
- `nix build .#darwinConfigurations.suzuMac.system`: builds the macOS system target used by CI.
- `nix shell nixpkgs#neovim nixpkgs#git -c ./scripts/nvim-restore.sh ~/.config/nvim`: restores Neovim plugins from `lazy-lock.json`.
- `nix shell nixpkgs#neovim nixpkgs#git -c nvim --headless "+qa"`: smoke-tests Neovim startup.

## Coding Style & Naming Conventions
- Prefer existing Nix and Lua style in the file being edited.
- Use 2-space indentation in Nix and Lua files unless the surrounding code already differs.
- Name new modules by tool or feature, for example `home-manager/programs/direnv.nix` or `.config/nvim/lua/plugins/git/gitsigns.lua`.
- Keep comments brief and practical. Avoid broad refactors or unrelated cleanup.

## Testing Guidelines
There is no dedicated unit-test suite. Verify changes with the narrowest command that exercises the touched area.

- Nix changes: `nix flake check` or the relevant `nix build` target.
- Neovim changes: run the headless startup check above.
- WezTerm changes: rely on the `wezterm-linter` workflow pattern when touching `.config/wezterm/**`.

## Commit & Pull Request Guidelines
Recent commits use short emoji-prefixed Conventional Commit style, often with a scope, for example `✨ feat(nvim): ...` or `🔧 chore(nix): ...`.

- Keep commit messages focused and descriptive.
- PRs should explain what changed, why it changed, and how it was verified.
- Include screenshots only for visible UI or terminal presentation changes.

## Security & Configuration Tips
- Never commit or inspect `.config/nix/secrets/secrets.yaml` unless absolutely necessary.
- Be careful with out-of-store symlinks and local-path assumptions in the Nix config.
- Avoid touching unrelated files, especially generated backups and lockfiles, unless the change requires it.
