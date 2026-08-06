# Git Commit Rules

## Eligibility

Commit only when:

1. All applicable tests, builds, linters, and other checks directly exercising the change pass.
2. It adds no compiler or linter warnings.
3. It is one logical unit.

Unrelated pre-existing failures or warnings do not block the commit. Report them to the user; do not fix them in the same commit.

## Message

Use either subject form:

- `<emoji> <type>(<scope>): <subject>`
- `<emoji> <type>: <subject>`

Include the optional scope only when useful. Start the subject with a lowercase letter, except for proper nouns, acronyms, and identifiers whose case must be preserved. Emphasize why the change is needed, not what changed.

### Types

- `feat` ✨ Add a feature.
- `fix` 🐛 Fix a bug.
- `docs` 📝 Change documentation.
- `style` 💄 Change formatting without changing behavior.
- `refactor` ♻️ Restructure code without fixing a bug or adding a feature.
- `perf` ⚡️ Improve performance.
- `test` ✅ Add or change tests.
- `chore` 🔧 Change configuration or development tooling.
- `revert` ⏪ Revert an earlier commit.
- `deps` 📦 Add or update dependencies.

### Body

- Omit it when the subject makes the reason self-evident.
- Otherwise, include only relevant details:
  - A non-obvious reason for the change.
  - A breaking change.
  - Migration instructions or cautions.
  - Related issues or pull requests.
- Always include it for breaking changes, security fixes, data migrations, and reverts, even when the subject is self-explanatory.
- Wrap lines at 72 characters.
- Use `-`, never `*`, for list items.
- Put any issue or pull request references last, as a footer such as `Closes #12` or `Refs #49`.

## Boundaries

- Prefer small, frequent commits.
- Each commit must function when applied and be independently safe to revert.
- Do not commit work in progress.
- An implementation, its direct tests, and required usage documentation may form one logical unit.
- Split concerns that can be verified and reverted independently into separate commits.
