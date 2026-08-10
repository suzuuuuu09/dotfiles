# Project Knowledge Guide

Use this guide to decide when and how to read or update the `KNOWLEDGE.md` file at a repository root. Its purpose is to preserve durable, project-specific lessons that prevent repeated mistakes, incorrect assumptions, and unnecessary rediscovery.

## Start of Repository Work

After the applicable instructions direct you to this guide, complete these steps before any other repository investigation or modification:

1. Read this guide.
2. Check whether the repository-root `KNOWLEDGE.md` exists.
3. If it exists, read it in full. If it does not exist, continue without creating it.

Complete this startup check when beginning a repository task. Repeat it before resuming the task after moving to another repository and returning, or after a break that may have discarded or replaced working context, including context compaction. Do not repeat it for another action during uninterrupted work on the same task in the same repository. Elapsed time, an ordinary conversation turn, or a recoverable tool failure does not by itself end uninterrupted work while the repository, task, and working context remain available. Do not inspect implementation, run `git status`, or modify files until the required check is complete.

## When a Lesson Is Ready

A lesson is ready to record only when all of these are true:

- Evidence has established the root cause, correct handling, a reusable reason to avoid a failed approach, or durable rationale for a design decision.
- The lesson is specific to this project and is likely to help a future agent.
- It is not obvious from the code and is not already clearly documented elsewhere.
- It can be stated as durable guidance without relying on the chronology of the current task.

Evidence may come from reproduction, tests, inspected implementation, version-specific tool behavior, authoritative documentation applicable to the project, or a confirmed design decision.

A lesson is not ready while it is still a hypothesis, under investigation, unreproduced, or supported only by a temporary workaround.

As soon as a lesson becomes ready, update `KNOWLEDGE.md` before continuing the task. Determining readiness includes evaluating the evidence against the criteria above and choosing the appropriate update to the entries already read at startup. Once that decision is complete, drafting and applying the update must be the next task-progress action; do not begin further investigation, implementation, or verification first. If existing-change safety rules prevent an immediate update, stop task progress and resolve that conflict instead of bypassing it or continuing with the update deferred. Do not defer the update until the end. Do not force an update at task completion when no lesson became ready.

## Choose the Update

- If no `KNOWLEDGE.md` exists, create it only when the first lesson is ready.
- If a related entry exists, update it instead of adding a duplicate.
- Replace or remove outdated guidance instead of appending a conflicting entry.
- Merge related lessons under a descriptive section when that improves retrieval.
- If the information is already obvious from code or clearly documented elsewhere, do not update `KNOWLEDGE.md`.
- If later evidence disproves a recorded lesson, correct or remove it as soon as the conflict is confirmed.

A confirmed lesson update is a normal part of the current task; do not ask for permission solely because it changes `KNOWLEDGE.md`. Preserve existing user changes and follow the repository's existing-change safety rules if an update overlaps them.

## Write the Lesson

Write all content added to or revised in `KNOWLEDGE.md` in English. Do not translate or rewrite unrelated existing content solely to enforce this rule.

Record the lesson, not the incident. Keep it concise, project-specific, and actionable. Prefer this form when appropriate:

```markdown
**<Topic>**
<What future agents should know.>

*Avoid*: <mistake or incorrect assumption>
```

Use `*Avoid*` only when it adds a useful prevention rule. Do not use `KNOWLEDGE.md` as a changelog, scratchpad, TODO list, incident log, or task history.

## Examples

Record immediately when confirmed:

- A reproduced failure establishes a non-obvious root cause and verified handling.
- You make a mistake, then verify a project-specific rule that would prevent recurrence.
- Observed behavior disproves an assumption and the correct behavior is verified.
- A failed method yields a stable, reusable reason to avoid it.
- A design decision has durable rationale that future work is likely to revisit.

Wait; do not record yet:

- A cause is plausible but remains a hypothesis.
- Investigation or reproduction is still in progress.
- Behavior has not been reproduced or otherwise confirmed.
- Only a temporary workaround is known.

Do not record:

- Facts already clear from checked-in code, configuration, or project documentation.
- One-off task outcomes, transient environment state, or progress notes.
- Generic engineering advice that is not specific to the project.

## Completion

Include any `KNOWLEDGE.md` change in the final report with the other task changes. If no lesson became ready, leave the file untouched, do not create an empty one, and state in the final report that no knowledge update was made. If the file was absent at startup, also state that it remains absent.
