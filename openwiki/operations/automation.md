---
type: operational subsystem
title: Automation and repository operations
description: GitHub Actions, Renovate, reusable Nix setup, operational shell scripts, permissions, triggers, and documentation update automation.
tags: [github-actions, renovate, operations]
---

# Automation and repository operations

`.github/workflows/` contains separate workflows for Nix builds, Neovim restoration, WezTerm loading, GitHub Action lint/security, Renovate validation/update, and OpenWiki updates. Actions are pinned to commit SHAs. The reusable `.github/actions/setup-nix/action.yaml` installs Nix and configures Cachix pull/push behavior; it accepts `authToken` and `skipPush`, so pull requests can use caches without pushing. The flake’s `nixConfig` declares three substituters and trusted public keys; WSL host settings persist a narrower cache set. Treat cache trust as an input to build availability, not as a correctness test.

The Nix build workflow runs Darwin checks and `darwinConfigurations.suzuMac.system` on `macos-26`, then builds `nixosConfigurations.suzuWsl` on `ubuntu-24.04`; ordinary jobs use `contents: read`, concurrency cancels superseded runs, and checkout credentials are not persisted. Path filters intentionally limit expensive workflows, so shared-file changes should be checked against both direct and indirect consumers.

`nix flake check` runs ShellCheck over `scripts/*.sh` and `.config/aerospace/scripts/*.sh`; `scripts/nvim-restore.sh` has an end-to-end workflow, while `pip-follow.sh` remains dependent on live AeroSpace state. Renovate configuration and its validator govern dependency proposals; `flake.lock`, `lazy-lock.json`, and pinned action SHAs are separate update surfaces.

The OpenWiki workflow is scheduled/manual, uses full history, installs pinned documentation tooling, and runs the repository wiki update flow. It is allowed to change documentation/workflow paths and treats `AGENTS.md` and `CLAUDE.md` as relevant inputs. Documentation automation does not replace source-level validation of Nix, applications, or activation behavior.

## Operational checks

Use `nix flake check` for the consolidated local gate, then the narrow command in [`validation`](../architecture/validation.md). For a workflow change, run actionlint and the workflow-specific validator where available; review `on.paths`, permissions, action pins, secrets, and whether a `.yaml`/`.yml` extension is included. For shell changes, run ShellCheck; for Neovim, restore and start headlessly.
