# Agent Guidelines

This file provides defaults that apply to every repository. The current request and project-specific instructions closer to the work take precedence.

## Environment

- GitHub: suzuuuuu09
- Repositories: managed with ghq (`~/ghq/github.com/owner/repo`)

## Communication

- Communicate with the user in Japanese unless the user explicitly requests another language.
- Write examples of user-facing messages in Japanese, including questions, options, recommendations, and status updates.

## Investigation and Decision-Making

- Before investigating or changing a repository, review the applicable instructions, `git status`, and the relevant implementation, configuration, and tests. Review history only when it is needed for a decision.
- Distinguish confirmed facts, adopted assumptions, and unresolved decisions. Do not ask the user about facts that can be established within the repository.
- Prefer existing implementation patterns, naming, directory structure, and code style. Do not include cleanup or refactoring unrelated to the request.
- When a safe, reversible default exists and does not materially change the requirements, state the assumption and proceed without asking.
- Before starting changes that span multiple layers, alter external specifications or public behavior, add dependencies, or involve destructive operations, briefly explain the scope, principal risks, and verification method. Proceed when no user decision is needed.

## Implementation

- Treat requests such as “implement this” or “fix this” as authorization to implement the scope already identified in the conversation. Do not reconfirm unless a new, significant decision is required.
- Keep the change set to the minimum needed to satisfy the request. Preserve existing separation of concerns; where state and logic are separate, keep that structure. Do not abstract solely for hypothetical future use.
- When relying on the current specification of an external library, API, or CLI, first check its version and usage in the repository. Then use the `find-docs` skill when available; otherwise, verify the applicable version against an official primary source. Do not research external sources for work that can be decided from local information alone.
- Add dependencies only when necessary, and explain why they are needed and their impact.

## Existing Changes and Safety

- Treat existing uncommitted changes as the user’s work. Do not overwrite, revert, format, or stage them; keep them separate from your own changes. Stop and ask only when they overlap the target area and cannot be safely separated.
- Before a destructive operation, use read-only checks to identify the exact target, impact, and recovery method. Unless the target and method are explicitly approved in the same request, ask before proceeding. Do not recursively delete broad paths or paths containing unresolved variables.
- Do not normally read or edit files containing secrets, such as `.env` files. Handle them only when the user explicitly identifies the file and purpose and the work is essential; do not output their values. Never commit secrets. Before handling a template file, verify that it contains no secret values.

## Verification and Reporting

- After making changes, review the diff and run the smallest test, lint, build, or syntax check that directly verifies the modified area.
- If verification fails, determine where possible whether the failure predates your changes or was caused by them. Do not fix unrelated existing failures without authorization.
- Finally, briefly report the changes made, verification performed and its results, and any unverified items or remaining issues.

## Task-Specific Guides

When a detailed guide for the task appears in the list below, read it before beginning that work. Do not infer or refer to guides that do not exist. When adding a new detailed guide, add its applicability and link to this list.

- Before sending a question to the user (including when a skill or other instruction requires a question): reread `~/.codex/guide/core/asking-questions.md` immediately before drafting the question, including on every turn of a multi-turn interview. Every question must include `Qk/N`, explicit response options, the impact of each option, and a recommended response with its rationale.

## Git

- Other than read-only checks, perform Git operations only when the user explicitly requests them. A request to commit does not authorize pushing, tagging, or creating a pull request.
- When asked to commit, confirm the target diff and verification results, and do not mix in pre-existing changes.
