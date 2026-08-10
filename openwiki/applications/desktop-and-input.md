---
type: application subsystem
title: macOS desktop and input integration
description: macOS-only window management, borders, keyboard remapping, Japanese input, and desktop application configuration linked or activated by nix-darwin.
tags: [macos, desktop, input]
---

# macOS desktop and input integration

macOS Home Manager links AeroSpace, borders, and Karabiner configuration through `xdg.configFile`; system/user modules also configure macSKK, keyboard behavior, defaults, and SSH. `.config/aerospace/scripts/pip-follow.sh` is an executable window-management helper included in the flake ShellCheck check. Its behavior depends on AeroSpace and live window state, so there is no deterministic integration test in the repository.

The Homebrew manifest installs or records the GUI applications that consume these settings: AeroSpace, borders, macSKK, Karabiner-Elements, and other desktop applications. [`Homebrew operations`](../operations/homebrew.md) is canonical for installation ownership, while this page is canonical for configuration behavior and application boundaries.

AeroSpace changes should be checked with ShellCheck and reviewed against the invoking AeroSpace configuration. Input-method changes should be validated on macOS after activation because macSKK and Karabiner depend on host services and permissions that Nix evaluation cannot exercise.

```bash
nix flake check
nix build --no-link .#darwinConfigurations.suzuMac.system
```

The repository is personal and Apple-Silicon-specific; these settings are not a portable desktop profile.
