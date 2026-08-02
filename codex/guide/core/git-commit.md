# Git Commit Rules

## Commit Eligibility

Create a commit only when all of the following conditions are met:

1. All applicable tests, builds, linters, and other checks that directly exercise the change have passed.
2. The change introduces no new compiler or linter warnings.
3. The change represents one logical unit of work.

Pre-existing failures or warnings unrelated to the change do not block the commit. Report them to the user and do not include their fixes in the same commit.

## Conventional Commit Format

Use `<emoji> <type>(<scope>): <subject>` for the commit subject.

### Types

- `feat` = ✨ Add a feature.
- `fix` = 🐛 Fix a bug.
- `docs` = 📝 Change documentation.
- `style` = 💄 Change formatting without changing behavior.
- `refactor` = ♻️ Restructure code without fixing a bug or adding a feature.
- `perf` = ⚡️ Improve performance.
- `test` = ✅ Add or change tests.
- `chore` = 🔧 Change configuration or development tooling.
- `revert` = ⏪ Revert an earlier commit.
- `deps` = 📦 Add or update dependencies.

## Commit Boundaries

- Prefer small, frequent commits over large, infrequent commits.
- Each commit must remain functional when applied and be safe to revert independently.
- Do not commit work in progress.
- An implementation, its directly corresponding tests, and the documentation required to use it may form one logical unit of work.
- Split concerns that can be verified and reverted independently into separate commits.
