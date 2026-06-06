# Repository Guidelines

## Project Structure & Module Organization
This directory contains Nix-based macOS and Home Manager configuration fragments.

- `darwin/`: nix-darwin system modules (`default.nix`, `system.nix`, `homebrew.nix`).
- `home-manager/`: user-level configuration, package lists, and per-program modules.
- `home-manager/programs/`: one file per tool, with nested folders for grouped configs such as `czg/`.
- `overlays/`: custom package overlays for local package tweaks.
- `secrets/`: SOPS-managed secret material. Do not inspect or edit secrets unless required.

Keep changes local to the relevant module and preserve the existing split between system, user, and overlay logic.

## Build, Test, and Development Commands
This repo is usually applied through the parent dotfiles flake.

- `nix flake check`: evaluate the flake and run available checks.
- `nh home switch` or `nh os switch`: activate Home Manager or nix-darwin, depending on the target.
- `darwin-rebuild switch`: apply macOS system changes when not using `nh`.

Use the smallest command that exercises the area you changed.

## Coding Style & Naming Conventions
- Prefer Nix attrsets with short, explicit imports.
- Keep function arguments vertically aligned, matching existing files.
- Use 2-space indentation and trailing semicolons where required by Nix syntax.
- Name new modules by feature or tool, for example `home-manager/programs/direnv.nix`.
- Keep comments brief and practical; existing Japanese comments may be preserved.

## Testing Guidelines
There is no dedicated unit-test suite here. Verify changes by evaluating the affected Nix modules and, when safe, switching the target configuration.

- Prefer `nix flake check` for broad validation.
- For targeted changes, run the relevant activation command after evaluation succeeds.

## Commit & Pull Request Guidelines
Recent commits use short, emoji-prefixed Japanese summaries, often with a scope in parentheses, for example `⚡️ ... (nix)` or `🩹 ... (workflow)`.

- Keep commits focused and descriptive.
- PRs should explain what changed, why it changed, and any activation or migration steps.
- Include screenshots only when the change affects visible UI or terminal presentation.

## Security & Configuration Tips
- Never commit or print secret values from `secrets/secrets.yaml`.
- Preserve `nix.conf` settings for flakes and trusted caches unless there is a clear reason to change them.
- Be careful with out-of-store symlinks in `home-manager/dotfiles.nix`; they depend on the local dotfiles checkout path.
