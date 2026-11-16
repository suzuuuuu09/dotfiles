---
name: deepseek-delegate
description: Delegate a bounded implementation, bug fix, or mechanical refactor to OpenCode with DeepSeek Free via Nix. Use when the user asks Codex to delegate coding to DeepSeek/OpenCode, or explicitly invokes $deepseek-delegate. Codex owns planning, diff review, tests, and final delivery; OpenCode only implements. Do not use for trivial edits or tasks the user wants Codex to implement directly.
compatibility: Requires Nix with flakes, git, bash, and authenticated OpenCode. Designed for Codex on macOS or Linux/WSL.
metadata:
  version: "1.0.0"
---

# DeepSeek Delegate (Nix + OpenCode)

Codex is the orchestrator and reviewer. OpenCode is a **separate implementer**, using only explicitly allowed free models. This skill follows the brief -> dispatch -> inspect diff -> independently verify pattern used by `amElnagdy/delegate-skills` (https://github.com/amElnagdy/delegate-skills/tree/master/skills/opencode-delegate), adapted to the user's Nix workflow.

## Boundaries

- Prefer direct implementation when writing the brief and reviewing the result would cost more than implementing the change. If the user explicitly requests delegation, honor it and keep overhead small. Delegate one coherent, independently testable task at a time.
- Never delegate planning, approval, review, or final acceptance. Codex owns those decisions.
- Never allow OpenCode to commit, push, amend commits, change remotes, reset/clean the repository, or call another coding agent.
- Never silently change models to paid ones. The only permitted models are:
  - Default: `opencode/deepseek-v4.1-flash-free`
  - Optional fallback after verifying it is still free: `opencode/glm-5.3-flash-free`
- Treat free access as temporary. If an allowed model becomes unavailable, stop delegation and report the limitation; never choose a paid model.
- Do not give the implementer credentials, .env content, secrets, deployment credentials, or unrelated private files. OpenCode runs with the current user's local permissions, not in a security sandbox.
- Do not run concurrent OpenCode jobs editing the same working tree. Do not delegate during an unresolved git conflict.

## 1. Preflight

1. Read repo `AGENTS.md` and relevant project instructions, inspect `git status --short`, and identify the exact affected files and validation commands. Do not assume `npm`; use the repo's package manager (often `bun`).
2. Check `nix --version` and (first use only) `nix run github:numtide/llm-agents.nix#opencode -- --version`.
3. Check available models with `nix run github:numtide/llm-agents.nix#opencode -- models`; require the exact selected free model ID. Authenticate through OpenCode if required; do not invent or read credentials.
4. If the working tree is dirty, identify pre-existing edits and their overlap with the delegation scope. Never run over overlapping edits without the user's explicit permission. The dispatch helper refuses dirty trees unless passed `--allow-dirty`.

## 2. Write a self-contained task brief

OpenCode does not have Codex's conversation history. Write a brief into a temporary UTF-8 file outside the repository (`mktemp`), using the structure in `references/brief-template.md`:

- Goal, relevant context, affected paths, specific requirements, and non-goals.
- Acceptance criteria and **actual project-specific** build/typecheck/test commands.
- Explicit instructions: modify only in-scope files; do not commit/push; no destructive shell commands; do not recurse to another agent; report changes and tests.
- Keep the brief concise: include only context needed to implement and verify the scoped change. Reference relevant files instead of pasting conversation history. Request a short final report with paths, checks, and blockers; inspect the actual diff yourself. Do not paste secrets or unrelated files.

## 3. Dispatch with the provided helper

From the target repository, run:

```sh
dispatch_log="$(mktemp "${TMPDIR:-/tmp}/deepseek-dispatch.XXXXXXXX")"
bash "$HOME/.agents/skills/deepseek-delegate/scripts/dispatch.sh" \
  --repo "$PWD" \
  --brief "/absolute/path/to/brief.md" >"$dispatch_log" 2>&1
exit_code=$?
printf 'Dispatch exit code: %s\nDispatch log: %s\n' "$exit_code" "$dispatch_log"
```

If the skill is installed in a repository rather than globally, resolve `scripts/dispatch.sh` relative to this `SKILL.md` instead of assuming `$HOME`.

- The helper uses `nix run github:numtide/llm-agents.nix#opencode -- run --model opencode/deepseek-v4.1-flash-free --agent build` with the entire brief as one argument.
- It records stdout/stderr, exit status, and post-run git status in a private temporary directory. The printed output directory path is authoritative; do not fabricate results.
- It does **not** use `--auto` by default. If the run cannot proceed because of a permission prompt, review and configure safe permission rules. Only pass `--auto` after the user explicitly approves unattended tool execution, understanding its local-system access.
- An optional fallback may be specified with `--model opencode/glm-5.3-flash-free` **only** after confirming it is free and appropriate. Never use arbitrary model IDs.
- If the tree was dirty and delegation remains safe after review, pass `--allow-dirty` intentionally. Capture the preexisting diff first so changes can be distinguished.
- Keep verbose output in the dispatch log rather than loading tool-by-tool progress into Codex context. If the command yields a running session, wait for completion with empty polls and a small output budget; give brief user updates without repeatedly reading the log.
- After completion, extract the authoritative output directory and exit code from the dispatch log, then read only the short final report. On failure, timeout, or a permission prompt, read the relevant log excerpt; expand only as needed to diagnose it. Keep the full log available as evidence.
- Do not claim completion merely because dispatch started. Read its exit code and inspect actual files.

## 4. Independently review

1. Check dispatch exit status and report. If it failed, diagnose without repeatedly firing paid/unknown models.
2. Review the final diff once; revisit only changed or unresolved portions after a fix. Inspect `git status --short`, `git diff --check`, `git diff --stat`, and the actual `git diff`; inspect new untracked files separately. Verify scope, behavior, security, and unwanted changes. Compare against any preexisting user edits.
3. Run the actual repository validation commands yourself (e.g. `bun run lint`, `bun run typecheck`, `bun test` only where they exist). Do not rely on OpenCode's report.
4. If changes are insufficient, produce a **new bounded brief** and delegate again only if safe. Do not automatically trust or merge the result.
5. Report the files changed, checks run/results, unresolved risks, and that no commit/push was performed. Do not commit/push unless the user explicitly asks.
6. When comparing token savings, use matching task and validation scope. Report cached input, uncached input, and output separately; keep free OpenCode usage separate from Codex usage. Claim savings only with measured comparable runs, and disclose extra benchmarks or checks rather than attributing their cost to delegation.

## Troubleshooting

- Nix missing or flake download fails: report exact command/error; do not switch installation method silently.
- Auth missing: instruct the user to authenticate OpenCode via Nix-run CLI; do not collect credentials in the brief.
- Free model missing: refresh model list if supported and check official OpenCode pricing; do not attempt a similarly named paid model.
- Permissions block headless execution: do not solve by blindly enabling `--auto`.
- Dirty repository: identify overlapping edits before considering `--allow-dirty`; never reset or stash user work without authorization.
