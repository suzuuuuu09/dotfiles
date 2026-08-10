---
type: navigation guide
title: Repository wiki quickstart
description: Entry point for understanding and safely changing this personal macOS and NixOS-WSL dotfiles repository, its Nix outputs, linked applications, agent environment, and validation paths.
tags: [quickstart, navigation, dotfiles]
---

# Repository wiki quickstart

This repository is a personal, flake-first environment definition for Apple-Silicon macOS and NixOS-WSL. Start with [`architecture overview`](architecture/overview.md) for composition, then choose the target system: [`macOS`](systems/macos.md) or [`NixOS-WSL`](systems/wsl.md). Shared user behavior lives in [`common Home Manager`](systems/common-home.md); package wiring is documented in [`packages and overlays`](systems/packages-and-overlays.md).

## Map

- [`Architecture`](architecture/overview.md) — flake outputs, module boundaries, data flow, and invariants.
- [`Validation and CI`](architecture/validation.md) — local checks, workflow matrix, triggers, and limitations.
- [`Common Home Manager`](systems/common-home.md) — packages, links, programs, secrets boundary, and shared behavior.
- [`Packages and overlays`](systems/packages-and-overlays.md) — local package definitions and consumers.
- [`macOS`](systems/macos.md) — nix-darwin, Home Manager, system defaults, aliases, and launchd.
- [`NixOS-WSL`](systems/wsl.md) — WSL host and standalone Home Manager outputs.
- [`Agent and Codex environment`](systems/agent-environment.md) — instructions, skills, transforms, and installed paths.
- [`Neovim`](applications/neovim.md) — lazy.nvim bootstrap, lockfile, restoration, and startup check.
- [`Terminal and shell`](applications/terminal-and-tools.md) — Fish, terminals, shells, and linked CLI configuration.
- [`Desktop and input`](applications/desktop-and-input.md) — AeroSpace, borders, Karabiner, macSKK, and GUI integration.
- [`Development tools`](applications/development-tools.md) — mise, VDE, cxr, Git tools, and utilities.
- [`Homebrew`](operations/homebrew.md) — managed/manual apps, trust state, custom cask, and activation.
- [`Secrets and activation`](operations/secrets-and-activation.md) — SOPS, links, generated state, and recovery.
- [`Automation`](operations/automation.md) — GitHub Actions, Renovate, setup action, scripts, and OpenWiki updates.

## Task routing

| Intent | Canonical page | Source entrypoints | Focused validation |
| --- | --- | --- | --- |
| Add/change a Nix output or module | [Architecture](architecture/overview.md) | `flake.nix`, `.config/nix/hosts/*`, Home Manager `default.nix` | `nix flake check`; target build |
| Change shared packages or overlays | [Packages and overlays](systems/packages-and-overlays.md) | `flake.nix`, `.config/nix/overlays/`, `packages.nix` | `nix flake check` |
| Change macOS defaults, launchd, or aliases | [macOS](systems/macos.md) | `.config/nix/home/darwin/system.nix`, `home-manager-launchd.nix` | Darwin build |
| Add/change Homebrew app | [Homebrew](operations/homebrew.md) | `homebrew.nix`, `.config/nix/homebrew/Casks/` | Darwin build; activation when safe |
| Change shared linked application config | [Common Home Manager](systems/common-home.md) or application pages | `.config/nix/home/common/dotfiles.nix`, owning `.config/*` | `nix flake check`; app-specific check |
| Change Neovim/plugins | [Neovim](applications/neovim.md) | `.config/nvim/`, `lazy-lock.json`, `scripts/nvim-restore.sh` | restore + `nvim --headless "+qa"` |
| Change skills or agent policy | [Agent environment](systems/agent-environment.md) | `agent-skills.nix`, `skills/`, `codex/`, instruction files | `nix flake check`; Ruff for Python |
| Change secrets or activation state | [Secrets and activation](operations/secrets-and-activation.md) | `sops.nix`, encrypted secrets, activation modules | target build; never inspect plaintext |
| Change CI, updates, or scripts | [Automation](operations/automation.md) | `.github/workflows/`, `.github/actions/`, `scripts/` | actionlint/ShellCheck; workflow-specific check |

## Baseline commands

```bash
nix flake check
nix fmt
nix build --no-link .#darwinConfigurations.suzuMac.system
nix build --no-link .#nixosConfigurations.suzuWsl.config.system.build.toplevel
```

Apply only on the intended host: `sudo darwin-rebuild switch --flake .#suzuMac` for macOS or `sudo nixos-rebuild switch --flake .#suzuWsl` for WSL. The configuration expects the checkout at `~/dotfiles`; it is not a generic template. Keep encrypted SOPS data encrypted and do not document credentials or private keys.

## Scope boundaries

Nix inputs are pinned by `flake.lock`, Neovim plugins by `.config/nvim/lazy-lock.json`, and GitHub Actions by commit SHA. Homebrew, some plugins, skill sources, and Lazy.nvim bootstrap still require external runtime access. CI builds closures and syntax/configuration checks but does not prove live WSL boot, desktop behavior, Homebrew success, or agent-skill semantics.
