# Delegation brief template

Fill in concrete project details before sending. OpenCode receives **no** orchestrator chat history.

## Goal
[One precise deliverable and the reason it is needed]

## Context
[Relevant design decisions, existing patterns, and known problems]

## Allowed scope
- Files/directories to inspect: [paths]
- Files/directories that may be edited: [paths]
- Do not edit: [paths or subsystems]

## Requirements
1. [Expected behavior]
2. [Edge case]
3. [Compatibility constraint]

## Acceptance criteria
- [Observable testable outcome]
- [Any required failure behavior]

## Validation
- `[command discovered from this project's scripts]`
- `[other applicable command, or 'none']`

## Restrictions
- Do not commit, push, rebase, reset, clean, or delete unrelated files.
- Do not read or print secrets; do not deploy or perform network-side mutations.
- Do not invoke another agent.
- Only change files within allowed scope; report blockers rather than expanding scope.

## Final report
- Summary of modifications
- Files touched
- Tests/commands executed and their outcomes
- Remaining limitations or failures
