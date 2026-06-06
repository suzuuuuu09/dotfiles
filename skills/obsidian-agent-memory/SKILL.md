---
name: obsidian-agent-memory
description: "Read Obsidian memories first whenever the user asks to remember, check prior context, or starts a new task with reusable context; then write back durable outcomes after the task."
---

## Quick Start

When the task may reuse prior context, do this before any other work:

1. Read relevant project memory first.
2. If nothing relevant exists, search `troubleshooting/`, `reference/`, `learning/`, `architecture/`, and `tools-commands/`.
3. Write back durable outcomes after the task.

**Do not answer or plan the task before this read step.**

# Obsidian Agent Memory

A skill for persisting notes in an Obsidian vault to maintain knowledge across multiple conversations.

**Vault Location:** `~/Documents/Vault/`
**Memory Folder:** `memories/`

## Overview

Use this skill to save, organize, and retrieve notes. 

When this skill is active, prioritize "reading first" before performing tasks.

- **Project-related:** Save under `memories/projects/`
- **Others:** Create auto-categorized folders directly under `memories/`

## Trigger Policy

Use this skill under the following conditions:

1. The user explicitly requests to "save," "record," or "remember."
2. The user requests to "check previous content" before proceeding.
3. Durable decisions that should be reused in the future are made, even without an explicit request (e.g., policies, constraints, causes of failure, next TODOs).
4. Conversation starts with existing project context where prior notes are relevant.
5. Immediately before starting a new implementation, research, or debugging task.

Conversely, you may skip saving for casual conversation or transient information with low reuse value.

### Trigger Strength

- **Strong Trigger (Immediate Execution):**
  - Phrases like "check previous notes," "look at notes first," "remember this," "record this."
  - Statements like "use this policy from now on," "continue with this constraint."
  - Intent to "start implementing," "begin a task," or "proceed" (when project context exists).
- **Weak Trigger (Evaluate Context First):**
  - Suggestions (e.g., "Shall we try...?") where the policy is not yet confirmed.
  - Single-turn questions with low reuse value.

*Note: Even with a weak trigger, save if the reuse value (future constraints, policies, or troubleshooting insights) is high.*

### Re-reading Boundary Rules

- Re-read after 30 minutes of inactivity, even if the task is the same.
- Re-read if requirements, policies, or personnel change, even if inactivity is less than 30 minutes.

Conditions for a "New Task" (any one of the following):

1. User purpose changes (e.g., implementation to research, research to fix).
2. Output type changes (e.g., code change to design proposal, implementation to operational procedure).
3. Scope changes (e.g., different project, module, or feature).
4. User explicitly declares a switch (e.g., "next," "on another note," "from here on").

### Implicit SAVE Criteria (Reuse Value)

Save without an explicit request if the content includes:

1. Continuity policies ("use this from now on," "same as next time").
2. Constraints (version pinning, prohibited actions, operational rules).
3. Reoccurring failure insights (causes and workarounds).
4. Clear decisions for future TODOs.

## Execution Flow (Read First)

### 1) Reading at the Start of a Conversation

Before beginning work, retrieve and read relevant notes:

1. Extract the current repository name, tech stack, and user request summary.
2. Check `memories/projects/{project-name}/` as the highest priority.
3. If irrelevant, search across `reference/`, `learning/`, `troubleshooting/`, `architecture/`, and `tools-commands/`.
4. Review summaries and update dates; synthesize only what is relevant to the current task.

If the user explicitly asks to "check previous notes first," perform READ immediately before any other work.

### 2) Re-checking Before Starting Tasks

Re-read relevant notes immediately before starting a new task:

1. Identify the task type (implementation, research, debug, design, operations).
2. Prioritize reading relevant categories:
  - Impl/Research: `reference/`, `learning/`
  - Debug: `troubleshooting/`
  - Design: `architecture/`
  - Command execution: `tools-commands/`
3. If past notes conflict with current requirements, prioritize the current request and update the note if necessary.

### 3) Fallback

If access is denied or no relevant notes exist, state this briefly and proceed without memory. Create a new note after the task to improve future retrieval accuracy.

### 4) Utilization Loop (Read -> Decide -> Use -> Writeback)

To turn notes into actual output, always follow this loop:

1. **Read:** Gather 0–10 candidate notes (if 0, state "no matching notes" and proceed).
2. **Decide:** Rate notes by relevance:
  - High: Directly applicable procedures, constraints, or known pitfalls.
  - Medium: Supplemental design policies or reference knowledge.
  - Low: Background info not used this time.
3. **Use:** Prioritize high-relevance notes for execution plans and implementation.
4. **Writeback:** Add new insights/diffs to notes after work to improve future accuracy.

### 5) Response Reflection Rules (Mandatory)

To ensure memory is put to use, include the following in your response:

1. Which memory policies were adopted (1–3 points).
2. Notes considered but not adopted, and why (one line each, at least one).
3. Where the new insights will be saved (Writeback location).
4. Re-reading order for the next session (project → cross-category).

*Note: Detailed long-form explanations are not required; keep it brief and focused.*

#### Response Template (Fixed)

In responses involving memory utilization, include these headers in this order:

1. `Adopted Notes`
2. `Non-Adopted Notes`
3. `Execution Plan`
4. `Writeback Destination`
5. `Next Re-reading Order`

In the Execution Plan, note the source at the end of each step as `[source: <path>]`.

### 6) Decision Log for Conflicts (Required)

If past notes and current requirements contradict each other, leave the following log in the body of the saved note:

```md
## Decision Log
- Previous policy: <Old Policy>
- New policy: <New Policy>
- Why changed: <Reason for prioritizing the current requirement>
- Effective from: <Date/Time when the change takes effect>
- Related old memo: <Path to the old memo>
```

### 7) Retry Rules for Failures

In case of a read failure, apply the following:

1. Retry the same operation at most once.
2. If it still fails, share which path failed to load in a single line and continue.
3. Once the task is complete, write back the failure record to `troubleshooting/` or under the target project directory.

### Overview of Vault Structure

```
~/Documents/Vault/
├── memories/
│   ├── projects/              # Project-specific notes (independent for each project)
│   ├── reference/             # General references and solutions (reusable across all projects)
│   ├── learning/              # Learning, discoveries, and patterns (applicable to multiple projects)
│   ├── troubleshooting/       # Troubleshooting (common problem solving)
│   ├── architecture/          # Architecture and design patterns (reusable)
│   ├── tools-commands/        # Collection of tools, commands, and snippets
│   └── inbox/                 # Unorganized notes (to be categorized into general folders later)
└── (Other vault content)
```

For details on the Vault structure and folder usage, please refer to `references/vault-structure.md`.

## Active Usage

### Saving General Notes (Reusable across projects)

Automatically save notes in each category in the following cases:

- **Learning**: Technical discoveries, patterns, best practices
  - Event loop mechanisms, performance optimization patterns, etc.
- **Reference**: Solutions, procedures, how-tos
  - Error resolution methods, API configuration, setup guides, etc.
  - **Feel free to create new categories**: react/, nix-darwin/, typescript/, etc.
- **Troubleshooting**: Recurring problems and solutions
  - Memory leak diagnosis, timeout handling, etc.
- **Architecture**: Reusable design patterns
  - Microservice patterns, caching strategies, etc.
- **Tools-Commands**: Frequently used commands, scripts, and settings
  - Docker commands, Git workflows, CLI settings, etc.
  - **Feel free to create new tool categories**: docker/, nix/, jq/, etc.

### Saving Project-Specific Notes

- Project-specific specifications, implementation notes, and settings.
- Information used only in a specific project.
- → Save in `memories/projects/{project-name}/`
- **Create subcategories as needed**: typescript/, database/, frontend/react/, etc.

### Searching and Referencing Notes

Check relevant general notes:

- When learning new technology → Check `learning/`
- When an error occurs → Check `troubleshooting/`
- When you want to know how to implement something → Check `reference/`
- When designing architecture → Check `architecture/`
- When you forget a command → Check `tools-commands/`
- For a specific technology stack (React, Nix, TypeScript, etc.) → Check the corresponding subcategory

## File Format

All notes must include Markdown frontmatter (YAML):

```yaml
---
summary: "A brief description of what this note contains (1-2 lines)"
created: 2025-01-15  # Use YYYY-MM-DD format (zero-padded)
---
```

Optional fields:

```yaml
---
summary: "Worker thread memory leak during large file processing - cause and solution"
created: 2025-01-15
updated: 2025-01-20
status: in-progress  # in-progress | resolved | blocked | abandoned
tags: [performance, worker, memory-leak]
related: [src/core/file/fileProcessor.ts]
---
```

## Note Operations

### Saving
For details on how to save notes, file naming conventions, and category selection, see the "Saving Notes" section in `references/operations.md`.

### Searching
For how to search within Obsidian or from the command line, see the "Searching Notes" section in `references/operations.md`.

### Management
For how to update, delete, merge, and reorganize notes, see the "Managing Notes" section in `references/operations.md`.

## Concrete Examples

For specific examples of various types of notes, refer to `references/examples.md`:
- Project notes (basics and hierarchy)
- Learning notes
- Reference notes (existing and new categories)
- tools-commands notes
- Workflow examples

## Guidelines

1. **Write self-contained notes**: Include complete context so it can be understood without prior knowledge.
2. **Make the summary decisive**: Ensure one can tell if they need to read the details just by reading the summary.
3. **Keep it up-to-date**: Update or delete old information.
4. **Be practical**: Only save what is actually useful. You do not need to save everything.
5. **Expand actively**: Do not hesitate to create new categories if you feel they are necessary.
6. **Use for decision-making**: Use notes not just as records, but as material for deciding on the next task.
7. **Feed back after work**: Always write back new failure examples, success examples, and procedure changes.

## Content of Notes

When writing detailed notes, consider including:

- **Context**: Goals, background, constraints
- **State**: What is finished, in progress, or blocked
- **Details**: Key files, commands, and code snippets
- **Next steps**: What to do next? Any unresolved questions?

Not all notes require every section. Use only what is relevant.

## Troubleshooting

For basic troubleshooting, see the "Troubleshooting" section in `references/operations.md`.

## Reference Materials

- **Vault structure details**: `references/vault-structure.md` - folder structure, flexibility, and the role of each folder
- **Examples collection**: `references/examples.md` - real-world examples of various note types
- **Operations guide**: `references/operations.md` - saving, searching, management, and troubleshooting
