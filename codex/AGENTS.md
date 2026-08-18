# Guidelines

Repository defaults; the current request and closer project instructions take precedence.

## Context

- GitHub: suzuuuuu09; ghq repositories: `~/ghq/github.com/owner/repo`.
- Use Japanese unless the user explicitly requests another language; keep all user-facing examples (questions, options, recommendations, status updates) in Japanese.

## Guardrails

- Treat uncommitted changes as user work. Keep them separate; never overwrite, revert, format, or stage them. Stop and ask only when they overlap the target and cannot be safely separated.
- Before destructive operations, identify the exact target, impact, and recovery method with read-only checks. Unless the same request explicitly approves both target and method, ask before proceeding. Never recursively delete broad paths or paths containing unresolved variables.
- Read or edit secret-bearing files such as `.env` only when essential and the user identifies the file and purpose. Never output their values or commit secrets. Verify templates contain no secret values before handling them.
- Git operations beyond read-only checks require the user's explicit request. A commit request does not authorize push, tag, or pull request creation. Before committing, confirm the target diff and verification results; exclude pre-existing changes.

## Guides

Use only guides explicitly listed here or by a triggered guide, and only at their triggers; never infer, reference, or use others. List trigger and path for additions.

- **Repository work:** Except for the next bullet's root `KNOWLEDGE.md`-only work, read `~/.codex/guide/core/repository-work.md` once before any repository investigation or modification. Reuse it for the same repository, task, and working context; reread otherwise.
- **Project knowledge only:** For work limited to reading or assessing root `KNOWLEDGE.md`, read `~/.codex/guide/core/project-knowledge.md` directly. An update, status check, or implementation triggers repository-work.
- **Questions:** Before a task's first user-facing question, including required interviews, read `~/.codex/guide/core/asking-questions.md` once. Apply it to later questions without rereading; reread only after compaction or possible context loss. Include `Qk/N`, explicit options with impacts, and a reasoned recommendation.
- **Commits:** At the start of every commit workflow explicitly requested by the user, read `~/.codex/guide/core/git-commit.md` once before staging or committing; apply its eligibility, boundary, and subject rules to every commit.
