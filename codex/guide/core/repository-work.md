# Repository Work

## Startup

Before `git status` or implementation, configuration, test, or history reads, ensure the Project Knowledge Guide startup is complete for this repository, task, and working context.

- If complete, reuse it; reread neither the guide nor root `KNOWLEDGE.md`.
- Otherwise, read `~/.codex/guide/core/project-knowledge.md` in full and complete its root `KNOWLEDGE.md` startup without batching later checks.

Repeat after repository/task change or possible context loss.

## Investigate and Decide

- Before work, review applicable instructions, `git status`, and relevant implementation, configuration, and tests; review history only when needed for a decision.
- Separate confirmed facts, adopted assumptions, and unresolved decisions. Establish repository facts rather than asking the user.
- Follow existing patterns, naming, directory structure, and code style; exclude unrelated cleanup or refactoring.
- When a default is safe, reversible, and does not materially change requirements, state the assumption and proceed without asking.
- Before multi-layer, external-specification, public-behavior, dependency, or destructive changes, briefly explain scope, principal risks, and verification; proceed when no user decision is needed.

## Implement

- Requests such as “implement this” and “fix this” authorize the scope already identified in conversation; reconfirm only for a new significant decision.
- Keep the change set to the minimum needed for the request. Preserve existing separation of concerns, including existing state/logic separation. Do not abstract solely for hypothetical future use.
- Before relying on current external library, API, or CLI specifications, check repository version and usage. Then use `find-docs` when available, or verify that version against an official primary source. Skip external research when local information suffices.
- Add dependencies only when necessary; explain why and their impact.

## Verify and Report

- Review the diff and run the smallest test, lint, build, or syntax check that directly verifies the modified area.
- On failure, determine where possible whether it predates or results from the change. Do not fix unrelated existing failures without authorization.
- Finally, briefly report changes, verification and results, unverified items, and remaining issues.
