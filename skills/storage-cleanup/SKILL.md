---
name: storage-cleanup
description: Inspect or clean shared caches for uv, pnpm, npm, Cargo, Bun, Homebrew and Xcode, and check Nix GC.
---

# Storage Cleanup

Measure volume free space and resolve cache paths and sizes. Report scope, re-downloads, and offline or link risks. Preserve project environments and outputs, installed tools, settings, and credentials.

Prefer built-in commands and dry runs. Delete only regenerable caches with approved paths, scope, and method. Defer during conflicting activity. Remeasure the same volume and distinguish actual gain from candidate sizes.

- uv — `uv cache dir`, `uv cache clean [package]`. Prune may remove project environments.
- pnpm — `pnpm store path`, `pnpm store prune`.
- npm — `npm config get cache`, `npm cache clean --force`. `npm cache verify` also deletes data.
- Cargo — `registry/` and `git/` under `CARGO_HOME` (default `~/.cargo`).
- Bun — `bun pm cache`, `bun pm cache prune` if supported. `bun pm cache rm` removes the linked store.
- macOS — `brew --cache` for downloads. `brew cleanup` can remove installed versions. Check Xcode's configured Derived Data. Preserve archives, simulator data, and runtimes.

With Nix installed, check GC schedule and outcome. Report missing, failed, or missed jobs. While the store is idle, suggest retries using the job's scope and retention, or manual GC using the user's explicit choices. Verify CLI syntax (`nh clean user` vs `nh clean all`, `--optimise`). The user runs GC.
