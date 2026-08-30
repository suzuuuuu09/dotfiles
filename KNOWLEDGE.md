# Project Knowledge

This file records project-specific knowledge whose rationale is difficult to recover from code or existing documentation and that is likely to prevent repeated mistakes.

## Nix and target environments

**Keep shared packages evaluable on both targets**
`.config/nix/home/common/` is imported by both macOS and NixOS-WSL, so a macOS-only package can break WSL evaluation even when it is used at runtime only on macOS.
Place Darwin-only packages such as `pngpaste` in `.config/nix/home/darwin/`, and verify both Darwin and WSL after moving a module from the common configuration.

*Avoid*: assuming that a macOS-only package is harmless in `home/common/` because it is used by a plugin that runs only on macOS.

**Check Git flake inclusion before verifying a new module**
This flake treats `self` as a Git source tree, so a newly created untracked file may not be visible to `nix build`.
When a new module is reported as missing, check `git status` and the file's tracking state before investigating Nix syntax or the import path.

## Pinned external dependencies

**Keep Hunk's nixpkgs independent from the root input**
During evaluation of `bun2nix` and `flake-parts`, Hunk enumerates `x86_64-darwin`, so a newer root nixpkgs can fail evaluation when that architecture is removed even if the host is `aarch64-darwin`.
`flake.nix` currently pins `hunk.inputs.nixpkgs` to `nixpkgs-26.05-darwin`.
When updating Hunk or nixpkgs, keep this independent pin and run `nix build --no-link .#darwinConfigurations.suzuMac.system` and `nix flake check`.

*Avoid*: restoring `hunk.inputs.nixpkgs.follows = "nixpkgs"` or updating the dedicated pin without confirming the reason.

**Use the `llm-agents.nix` package for Codex**
This repository's `codex` uses `inputs.llm-agents.packages.${system}.codex`, not `pkgs.codex` from nixpkgs.
When updating the Codex version or distribution source, preserve this reference in `.config/nix/home/common/programs/codex.nix` and verify the actual derivation in the generated `home.packages`.

## Agent Skills and macOS activation

**Avoid duplicate IDs when moving a personal skill to an external source**
`skills.enableAll = ["personal"]` discovers every skill under `skills/`, so registering the same skill from a pinned external source makes agent-skills-nix fail evaluation with a duplicate ID.
When the external source is the source of truth, exclude the local directory from `personal` or add an `idPrefix` to one of the sources.

**Treat the management marker in `~/.agents/skills` as the ownership boundary**
When `~/.agents/skills` is non-empty and lacks `.agent-skills-managed.json`, `agent-skills-nix` treats the directory as unmanaged and stops activation.
If the existing contents are links to an old Nix Store path, move the entire directory to a timestamped adjacent backup before deleting or force-overwriting it, then rerun the normal `darwin-rebuild switch --flake .#suzuMac`.

*Avoid*: permanently setting `AGENT_SKILLS_FORCE=1` without inspecting the contents, or deleting the old directory first.

**Provide Homebrew trust configuration for sudo activation paths**
During nix-darwin activation, Homebrew runs through sudo, so trust settings for the interactive user may not be used to verify taps or casks.
`.config/nix/home/darwin/homebrew.nix` explicitly sets `XDG_CONFIG_HOME` and generates trusted tap/cask entries in both `/Users/<username>/.homebrew/trust.json` and `/Users/<username>/.config/homebrew/trust.json`.
When adding a formula or cask from an external tap, update the managed list and the required trust list in the same change.
If the whole tap does not need to be trusted, prefer trusting an individual cask.

*Avoid*: solving every activation failure by disabling trust checks with `HOMEBREW_NO_REQUIRE_TAP_TRUST`.

## Formatters

**Check TOML formatting through Taplo's actual scope**
`nix fmt` runs Taplo through treefmt, and `.taplo.toml` sets `align_entries = true` for ordinary TOML entries.
Adding a setting alone may not change the file, and syntax outside the formatter's alignment scope, such as the inline table in `keymap.toml`, is not aligned in the same way.
Inspect the actual file after formatting.

*Avoid*: asserting how `=` is aligned from the formatter configuration alone, or expecting inline tables to align like ordinary entries.

## Fish-native prompt

**Do not stack nix-darwin Fish initialization on macOS**
This repository manages Fish's PATH and interactive behavior in the dotfiles.
On macOS, enabling `programs.fish.enable = true` makes nix-darwin run `foreign-env` even for empty `environment.shellInit`, `loginShellInit`, and `interactiveShellInit`, starting Bash on every invocation.
The nix-homebrew Fish integration also runs `brew shellenv`, and WezTerm starts `fish -l`, so all of these become part of the startup path.
The Home Manager direnv package provides `vendor_conf.d/direnv.fish`; do not regenerate the same hook from `tool_setup.fish`.

*Avoid*: enabling the system Fish integration while also stacking the dotfiles' initialization, or loading the direnv hook from both Nix and Fish.

**Classify Codex usage limits by App Server window duration; do not fetch them synchronously from the prompt**
Codex CLI's `account/rateLimits/read` returns `usedPercent` and `windowDurationMins`, but the positions of `primary` and `secondary` do not guarantee a fixed short-term or weekly window.
The five-hour (300-minute) window may be absent while only the weekly (10080-minute) window is returned, so Fish classifies limits by duration and queries the App Server in the background while reading only the local cache synchronously.

*Avoid*: assuming that `primary` is always the five-hour window, or starting `codex app-server` during every prompt render and adding roughly 0.6 seconds of latency.

**Powerline triangles inherit the background of the adjacent segment**
Oh My Posh's `leading_diamond` uses a transparent background and the current segment's foreground at the start, then the previous segment's background and the current segment's foreground at boundaries.
The Fish implementation tracks the previous background while rendering segments and assigns it to the `` cell.
The final `trailing_diamond` restores the current segment's foreground with a transparent background.
Fish 4.8's native `fish_transient_prompt` handles command acceptance and calls `fish_prompt --final-rendering` for the temporary prompt.

*Avoid*: rendering the triangle with only the foreground color and losing the previous segment's background, or reintroducing manual Enter/Ctrl-C repaint state for a Fish version that provides the native transient prompt.

## WezTerm

**The default tabline sections run synchronous child processes periodically**
The default `tabline_x` in `michaelbrusegard/tabline.wez` displays RAM and CPU usage.
On macOS, each update synchronously runs `vm_stat`, `ps` and `awk` through `bash`, and `sysctl`; each component is throttled for three seconds.
When startup and interaction latency matter, remove `ram` and `cpu` from `sections.tabline_x`.
The built-in string themes enumerate `wezterm.color.get_builtin_schemes()`, so pass the resolved color table to `options.theme` when the same appearance must be preserved while avoiding the configuration-load cost.

*Avoid*: assuming that cloning the plugin locally makes configuration loading and status updates cost-free.

## Agent instructions

**Keep project knowledge scoped to the KNOWLEDGE lifecycle**
`codex/guide/core/project-knowledge.md` governs only the root `KNOWLEDGE.md` lifecycle. General investigation, implementation, and verification belong in `repository-work.md`, which invokes the project-knowledge startup and reuses it when already complete for the same repository, task, and working context.

*Avoid*: merging general repository workflow into the project-knowledge guide to reduce pointer count.
