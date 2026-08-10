---
type: application subsystem
title: Development and utility tools
description: Shared development-tool and utility configuration linked by Home Manager, including mise, VDE, cxr, GitHub CLI, lazygit, and terminal utilities.
tags: [development-tools, cli, home-manager]
---

# Development and utility tools

The common link map exposes `mise`, `vde`, `cxr`, `git`, `gh`, `lazygit`, `bat`, `btop`, `gomi`, `herdr`, and `yazi` configuration. Packages and Home Manager program modules install the corresponding tools; local Nix package names and overlay wiring are documented in [`packages and overlays`](../systems/packages-and-overlays.md).

The important ownership rule is split: Home Manager declares installation and link destinations, while the application directories contain runtime behavior. `mise` and language/runtime configuration are shared only when compatible with both Darwin and WSL; macOS-only GUI and Homebrew tools belong to the macOS pages. `cxr` and `vde` are repository-specific tools whose package availability should be checked through the active overlay before changing their configuration.

Use `nix flake check` for Nix graph, formatting, Statix, deadnix, and pre-commit validation. There is no broad application integration suite; validate behavior with the narrow tool command after activation, and build the target system when package/platform selection changes.
