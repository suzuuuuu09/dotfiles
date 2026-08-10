---
type: package system
title: Local Nix packages and overlays
description: Repository-local package definitions exposed through flake overlays and consumed by shared or platform-specific configuration.
tags: [nix, packages, overlays]
---

# Local Nix packages and overlays

`flake.nix` defines `localOverlays` and applies `sharedOverlays` to the Darwin and WSL package sets. The overlay uses `prev.callPackage` for `.config/nix/overlays/czg.nix` and `.config/nix/overlays/cxr.nix`, and maps `hunk` to `inputs.hunk.packages.${_final.stdenv.hostPlatform.system}.hunk`. The resulting names `czg`, `cxr`, and `hunk` are available to Home Manager modules and packages. `czg` is a version-pinned `npx` wrapper; `cxr` is a fixed-source Rust package; `hunk` comes from the external package set. `.config/nix/overlays/herdr.nix` exists but is not in `localOverlays`, so it is not active merely by existing.

Inputs mix moving branch URLs (`nixpkgs-unstable`, nix-darwin `master`, Home Manager `master`, NixOS-WSL `main`), ordinary GitHub refs such as `treefmt-nix`, `nix-homebrew`, `sops-nix`, and agent-skills, explicit commit-pinned skill URLs (Context7, Mizchi, UI/UX, stop-ai-slop), and `flake = false` source trees for Vercel, Anthropic, agent-browser, and related skills. Resolved revisions are recorded in `flake.lock`, but changes to broad upstream sources can expand `enableAll` skills. `hunk` deliberately overrides its nixpkgs input to `nixpkgs-26.05-darwin` because its flake-parts evaluation is incompatible with dropped `x86_64-darwin`; the overlay then selects the host-platform package.

The overlay is a boundary between external flake inputs, repository-local derivations, and consumer modules. Keep package definitions platform-aware: `flake.nix` evaluates Darwin as `aarch64-darwin` and WSL as `x86_64-linux`, while `hunk` comes from its input’s package set. Inspect the package expression and its consumer before changing build inputs or installation behavior.

`home/common/packages.nix` is the principal shared consumer; program modules such as `programs/czg` and the application configuration may also refer to these names. Homebrew’s `managedBrews` separately installs macOS tools such as `herdr`, so Nix overlay ownership and Homebrew ownership must not be conflated. The repository also contains `.config/nix/overlays/herdr.nix`; verify whether it is currently imported before extending it, because an unreferenced expression is not part of the active flake graph.

## Change and validation surface

1. Update the relevant expression under `.config/nix/overlays/`.
2. Confirm its name is included in `localOverlays` and its consumer resolves on both target systems.
3. Run `nix flake check` for evaluation, formatting, Statix, deadnix, and pre-commit checks.
4. Build the affected target output, especially when the derivation has platform-specific dependencies.

There is no package unit-test suite; derivation evaluation and target builds are the focused evidence available.
