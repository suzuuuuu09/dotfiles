---
type: operational subsystem
title: Homebrew manifest and activation
description: macOS Homebrew ownership, trusted taps/casks, managed and manual applications, custom cask installation, and activation update semantics.
tags: [homebrew, macos, operations]
---

# Homebrew manifest and activation

`.config/nix/home/darwin/homebrew.nix` is the canonical Homebrew manifest. `trustedHomebrewTaps` and `trustedHomebrewCasks` define trust state; `managedBrews` and `managedCasks` are installed and updated by nix-darwin; `manualCasks` records applications that should remain outside automatic management. The module passes `homebrewManifest` through `_module.args` for related macOS modules.

The package split is explicit: common Home Manager packages install CLI tools such as Git, Neovim, Fish, tmux, `gh`, `lazygit`, `jujutsu`, `hunk`, `cxr`, Node/Python tooling, and media/file utilities; Darwin adds `pngpaste` in `home/darwin/packages.nix`. The authoritative Homebrew lists are: `managedBrews` = `mas`, `herdr`, `felixkratz/formulae/borders`, `bjarneo/cliamp/cliamp`; `managedCasks` = `nikitabobko/tap/aerospace`, `alt-tab`, `homerow`, `pear-devs/pear/pear-desktop`, `battery`, `wezterm@nightly`, `ghostty`, `macskk`, `gitusp/azoo-key-skkserv/azoo-key-skkserv`, `jordanbaird-ice`, `musescore`, `localsend`, `shottr`, `codex-app`, `tailscale-app`, `parsec`, and `eqmac`; `manualCasks` = `vivaldi`, `raycast`, `discord`, `slack`, `zoom`, `karabiner-elements`, `obsidian`, `amical`, `1password`, `visual-studio-code`, and `intellij-idea`. Manual casks are intentionally outside nix-darwin ownership and are not removed by activation.

Activation enables nix-homebrew with Rosetta and migration support, uses `/Applications` through `caskArgs.appdir`, refreshes metadata (`autoUpdate = true`), upgrades managed items, and deliberately sets `cleanup = "none"` so manual or unrelated applications are not removed. `wezterm@nightly` is explicitly `greedy`; this is an exception to normal update behavior.

```mermaid
flowchart TD
  Manifest[homebrew.nix] --> Trust[trusted taps and casks]
  Manifest --> Managed[managed brews and casks]
  Manifest --> Manual[manual casks retained]
  Activation[nix-darwin activation] --> Update[auto-update and upgrade]
  Activation --> TrustFile[~/.homebrew/trust.json and ~/.config/homebrew/trust.json]
  Activation --> Custom[install local azoo-key-skkserv cask]
  Managed --> Apps[/Applications]
```

The extra activation script creates trust directories, writes JSON with mode `0600`, copies it to both lookup locations, and installs the repository-local `.config/nix/homebrew/Casks/azoo-key-skkserv.rb` into `/opt/homebrew/Library/Taps/gitusp/homebrew-azoo-key-skkserv/Casks`. This requires macOS ownership/permissions and a working Homebrew prefix. A failure after Homebrew updates may leave external package state changed while the Nix generation is incomplete; inspect activation output before retrying.

Validate the Nix expression with `nix flake check` and build the Darwin system. Apply with `sudo darwin-rebuild switch --flake .#suzuMac`; network access and Homebrew’s external repositories are required. Adding an application requires deciding whether it is Nix-managed, managed by Homebrew, or intentionally manual.
