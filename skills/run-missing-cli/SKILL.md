---
name: run-missing-cli
description: Run an unavailable CLI transiently without installing it into the host, user, or project environment. Use after `command -v` fails or a task reports "command not found"; do not use when an existing executable fails for another reason.
---

# Run Missing CLI

1. Confirm absence with `command -v "<executable>"`. If present, stop and diagnose its arguments, permissions, configuration, or version.
2. Preserve the original command, arguments, working directory, and authorized side effects.
3. Try applicable routes in order, stopping at the first success:
   1. Repository wrapper, script, task, flake app, or dev shell.
   2. `direnv exec "<project-root>" <command> [args...]`, only for an existing, authorized environment. Never allow it, edit `.envrc`, or inspect loaded variables; redact their values from reported diagnostics.
   3. `, <command> [args...]`; never use `--install`/`-i` or guess an ambiguous provider.
   4. `nix run <flake>#<app> -- [args...]` for a known app.
   5. `nix shell <flake>#<package> -c <command> [args...]` for a known package when no app fits.

- Prefer project-pinned references; otherwise verify providers and Nix references from authoritative information.
- On timeout, stop the route, retain its output, and continue without retrying it.
- Never modify profiles, host/project configuration, dependencies, manifests, lockfiles, flakes, or task definitions to obtain the CLI. Unless explicitly requested, never use persistent installers such as comma install mode, Nix profiles, Homebrew/apt, global language-package installs, or remote install scripts. Nix-store and tool-cache downloads are allowed.
- A transient runner changes only tool availability; it does not expand authorization for side effects.
- If all routes fail, report the executable, attempts, exact failures, and remaining transient options. Ask for the smallest decision needed; do not silently substitute a tool or default to permanent installation.
