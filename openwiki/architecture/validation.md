---
type: validation guide
title: Validation and CI map
description: Local flake checks and workflow-specific validation for Nix systems, applications, scripts, GitHub Actions, Renovate, and documentation automation.
tags: [ci, validation, nix]
---

# Validation and CI map

The flake exposes `checks.aarch64-darwin.*`: `pre-commit` runs the imported git-hooks configuration; `formatting` runs treefmt’s check; `statix` runs `statix check ${self}`; `deadnix` runs hidden-tree dead-code analysis with `--fail`; `shellcheck` analyzes `scripts/*.sh` and `.config/aerospace/scripts/*.sh`; `fish-syntax` runs `fish -n` over `config.fish`, `tool_setup.fish`, `config/*.fish`, `conf.d/*.fish`, and `functions/*.fish`; `ruff` checks `skills/fetch-markdown/scripts` and `skills/timezone-utils/scripts`; and `actionlint` checks `.github/workflows/*.yaml`. `nix flake check` builds these check derivations; `nix fmt` applies the treefmt wrapper. The `*.yaml` glob does not include `.yml`, so workflow inventory must also account for `openwiki-update.yml` and other extensions through dedicated workflows.

| Intent | Narrow validation | Broader/conditional validation |
| --- | --- | --- |
| Nix/module/overlay change | `nix flake check` | Darwin or WSL target build |
| macOS system change | `nix build --no-link .#darwinConfigurations.suzuMac.system` | `sudo darwin-rebuild switch --flake .#suzuMac` |
| WSL system change | `nix build --no-link .#nixosConfigurations.suzuWsl.config.system.build.toplevel` | live WSL activation |
| Neovim change | restore script then `nvim --headless "+qa"` | plugin behavior/manual editor checks |
| Fish/shell script | flake Fish/ShellCheck checks | live shell or AeroSpace behavior |
| WezTerm change | WezTerm workflow/virtual-display load | interactive terminal validation |
| Actions change | actionlint and action-specific lint workflow | GitHub execution |
| Renovate change | Renovate config validator | actual update PR behavior |

`.github/workflows/nix-build.yaml` is path-filtered to `**/*.nix`, `flake.lock`, itself, and `.github/actions/setup-nix/action.yaml`; it builds the seven Darwin checks and the Darwin system on `macos-26`, then only the WSL NixOS toplevel on `ubuntu-24.04`. The build steps use `--keep-going` so independent derivations report together, while the final system build remains the target closure gate. It has `contents: read`, concurrency cancellation, and passes Cachix auth plus `skipPush` for pull requests to the composite setup action. The composite setup installs Nix, configures Numtide substitution, pulls from `nix-community` and the `suzuuuuu09` Cachix cache when available, and only pushes when an auth token exists and the event is not a pull request. A change only to a linked application file, encrypted secret, or an unlisted workflow may not trigger this workflow. The Neovim workflow has its own paths for `.config/nvim`, `lazy-lock.json`, the restore script, flake/setup files; WezTerm, action lint/security, Renovate, and OpenWiki have separate triggers. Inspect each workflow’s `on.paths`, permissions, pinned action SHAs, and local reproduction command before relying on a check as complete coverage.

The workflow validation jobs are not all equal: actionlint and the primary build steps are blocking; the `ghalint`, Zizmor, and GHAsec security-oriented jobs in `gh-action-lint.yaml` currently use `continue-on-error: true`, making them advisory. This repository has no conventional test directory; the flake checks and workflow jobs are the focused test ownership.

CI verifies evaluation and closure construction. It does not boot WSL, exercise Homebrew’s live network state, test desktop window behavior, or prove skill semantics. Nix inputs, Neovim plugins, and actions are separate pinning surfaces (`flake.lock`, `lazy-lock.json`, and action commit SHAs); update them with the relevant workflow and review boundary.
