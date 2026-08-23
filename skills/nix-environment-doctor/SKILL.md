---
name: nix-environment-doctor
description: Diagnose command-availability differences and Nix, Home Manager, or nix-darwin activation failures by tracing the failing process environment, executable provenance, declarative ownership, target imports, and activation phase. Use when a command works in one context but not another, resolves to an unexpected installation, or a Nix-managed environment fails to activate. Do not use merely to run a missing CLI, install a package, or redesign a Nix configuration.
---

# Nix Environment Doctor

Find the first boundary where declared configuration and observed behavior diverge. Diagnose before proposing changes; do not hide the cause by adding another installer or PATH entry.

## Establish the failing context

Identify the exact target environment and process where the symptom occurs: host, architecture, shell, login/interactive state, parent application, working directory, and executable name or activation command. Reproduce there when possible; a successful interactive shell is comparison evidence, not a substitute.

Collect only relevant environment facts. Do not dump all environment variables or inspect secret-bearing files. Start with commands such as:

```sh
command -v <executable>
type -a <executable>
printf '%s\n' "$SHELL" "$PATH"
```

Record the same facts in one known-working context when the problem is context-dependent. Compare the same small bundle in both contexts: all resolutions, resolved path, version, relevant PATH entries, and parent or launch method.

## Choose a diagnostic mode

### Command availability or unexpected version

Trace from observed executable back to its owner:

1. Resolve every matching executable and its symlink chain.
2. Classify each path by provider, such as a Nix store/profile, Home Manager generation, Homebrew, mise, or a language package manager.
3. Find the declarative source that is intended to own the executable. Inspect package lists, module imports, flake inputs, overlays, profiles, and project environments as applicable.
4. Compare the failing process's PATH and startup path with the working context. Check whether the process predates the current generation or bypasses shell initialization.
5. Check for shadowing, stale links, architecture mismatch, and package-name versus executable-name differences.

If the command is genuinely absent and the user only needs to run it transiently, stop this diagnosis and use the available missing-CLI workflow. Do not persistently install it as a diagnostic shortcut.

### Activation failure

Locate the earliest failing activation phase before changing configuration. Separate evaluation/build failures from activation-time failures such as Home Manager, application linking, Homebrew, launchd, defaults, secrets wiring, or service restart.

1. Capture the exact command, target, exit status, failed generation, and first actionable error; treat later cascading errors as secondary until shown otherwise. Anchor generated scripts and metadata to that failed generation rather than the current one.
2. Inspect the module import path and generated configuration for that phase.
3. Compare declared and currently active generations or services with read-only commands.
4. Check target-specific placement: shared modules must evaluate for every importing target; host-specific packages and services belong in the host-specific layer.
5. Check source inclusion when a flake uses a Git source: an untracked new module may be absent from evaluation.

Prefer the narrowest non-mutating evaluation or build that reproduces the phase. Do not run an activation command such as `darwin-rebuild switch`, install or remove packages, alter services, bypass trust checks, or delete state unless the user explicitly requested that mutation.

## Classify the root cause

Use the narrowest supported classification:

- missing declaration or missing import
- wrong target or architecture
- wrong provider or shadowed executable
- PATH or process-startup boundary
- stale generation, link, or long-running process
- evaluation or build failure
- activation-phase failure
- unknown because required evidence is unavailable

Do not call a hypothesis the root cause. If evidence stops at a boundary, report the boundary and the next read-only check.

## Recommend and verify

Prefer repairing the existing declarative owner or process boundary. Avoid adding a second package provider, global PATH workaround, duplicate shell hook, or host-specific package to a shared module.

After an authorized change, verify the original failing context first, then the working comparison context. For shared modules, verify every importing target. Use the smallest relevant check before broader flake checks or system builds.

Report:

1. **Symptom and contexts**: failing and working contexts.
2. **Confirmed evidence**: executable paths, providers, declarations/imports, or failing activation phase.
3. **Root cause**: one classification with the evidence that proves it, or an explicit unknown.
4. **Minimum correction**: exact ownership or boundary to change; do not apply it unless authorized.
5. **Verification**: commands run and results, plus any target or mutation left unverified.
