# Note Examples and Workflow

This document provides examples and workflows for various types of notes.

## Table of Contents

1. [Project Note (Basic)](#project-note-basic)
2. [Project Note (Hierarchical Structure)](#project-note-hierarchical-structure)
3. [Learning Note](#learning-note)
4. [Reference Note (Existing Category)](#reference-note-existing-category)
5. [Reference Note (New Category)](#reference-note-new-category)
6. [tools-commands Note (New Category)](#tools-commands-note-new-category)
7. [Workflow](#workflow)

## Project Note (Basic)

**Location**: `memories/projects/project-x/authentication-setup.md`

```markdown
---
summary: "Authentication flow implementation with OAuth2 and JWT tokens"
created: 2025-01-15
updated: 2025-01-20
status: in-progress
tags: [auth, oauth2, jwt, security]
related: [src/auth/oauth.ts, src/auth/jwt.ts]
---

# OAuth2 + JWT Authentication Flow

## Context
Project X requires secure authentication with external service integration.

## Implementation Details
- OAuth2 authorization code flow for user login
- JWT tokens for API authentication
- Refresh token rotation every 7 days

## Current State
- OAuth2 provider setup: DONE
- JWT token generation: DONE
- Token refresh endpoint: IN PROGRESS

## Files Modified
- `src/auth/oauth.ts` - OAuth2 handler
- `src/auth/jwt.ts` - JWT utilities
- `src/middleware/auth.ts` - Auth middleware

## Next Steps
- Implement token refresh endpoint
- Add logout endpoint
- Write integration tests
```

## Project Note (Hierarchical Structure)

**Location**: `memories/projects/my-app/frontend/react/component-patterns.md`

```markdown
---
summary: "my-app frontend: React component design guidelines"
created: 2025-01-15
status: in-progress
tags: [react, components, frontend, my-app]
---

# React Component Architecture for my-app

## Design Principles
- Presentational / Container pattern
- State management via custom hooks
- Avoiding props drilling

## Component Structure
```
src/components/
├── common/       # Reusable UI components
├── pages/        # Page-level components
└── features/     # Feature-based groupings
```

## Example
[Implementation example...]
```

## Learning Note

**Location**: `memories/learning/nodejs/event-loop.md`

```markdown
---
summary: "Node.js event loop: microtasks vs macrotasks execution order"
created: 2025-01-15
status: resolved
tags: [nodejs, eventloop, javascript]
---

# Node.js Event Loop Order

## Key Insight
Microtasks (Promises, async/await) execute BEFORE macrotasks (setTimeout, setInterval).

## Order of Execution
1. Synchronous code
2. Microtasks (Promises)
3. Render (browsers only)
4. Macrotasks (setTimeout, etc)

## Example
```javascript
// Microtask before macrotask
Promise.resolve().then(() => console.log('microtask'));
setTimeout(() => console.log('macrotask'), 0);
// Output: microtask, macrotask
```
```

## Reference Note (Existing Category)

**Location**: `memories/reference/cors-error-fix.md`

```markdown
---
summary: "Solution: Fix CORS errors with specific headers configuration"
created: 2025-01-15
status: resolved
tags: [cors, http, debugging]
---

# CORS Error Fix

## Problem
Request failed with CORS error when calling external API.

## Root Cause
API endpoint wasn't configured with proper Access-Control-Allow-Origin headers.

## Solution
Add these headers to response:
```
Access-Control-Allow-Origin: https://your-domain.com
Access-Control-Allow-Methods: GET, POST, OPTIONS
Access-Control-Allow-Headers: Content-Type, Authorization
```

## Prevention
Always check CORS headers in API responses before assuming client-side issue.
```

## Reference Note (New Category)

**Location**: `memories/reference/nix-darwin/home-manager-setup.md`

```markdown
---
summary: "Nix darwin environment: complete dotfiles management with home-manager"
created: 2025-01-15
updated: 2025-01-20
status: resolved
tags: [nix, darwin, configuration, home-manager]
---

# home-manager Setup on macOS

## Prerequisites
- Nix is installed
- macOS with Apple Silicon or Intel

## Installation
[Installation steps...]

## Configuration File Structure
```
flake.nix
├── inputs: home-manager
└── outputs: homeConfigurations
```

## Common Configurations
- Zsh / Fish shell configuration
- Tmux / Neovim configuration
- Development environment (Node, Python, Rust, etc.)

## Implementation Example
[Implementation example...]

## Tips
- Generational rollback is possible
- Shareable across multiple machines
```

## tools-commands Memo (New Category)

**Location**: `memories/tools-commands/nix/flake-commands.md`

```markdown
---
summary: "Commonly used Nix flake commands"
created: 2025-01-15
tags: [nix, flake, cli, commands]
---

# Nix Flake Commands Cheatsheet

## Environment Setup
```bash
nix flake init                    # Initialize from a template
nix flake show                    # Display flake contents
nix develop                       # Enter development environment
nix develop .#<name>             # Enter a specific development environment
```

## Build & Run
```bash
nix build                         # Build default package
nix build .#<name>               # Build a specific package
nix run                           # Run default app
nix run .#<name>                 # Run a specific app
```

## Update & Lock
```bash
nix flake update                  # Update flake.lock
nix flake update <input>          # Update a specific input
```

## Debugging
```bash
nix flake prefetch <url>          # Prefetch a URL
nix eval                          # Evaluate Nix expressions
```
```

## Workflow

### Saving General Memos

1. User shares or finds useful discoveries or solutions.
2. **Determine memo type**: Project-specific or reusable across multiple projects?
3. Select the appropriate category (learning, reference, troubleshooting, architecture, tools-commands).
4. **Determine if a new category is needed**: Is it knowledge specific to a tech stack? → Create a subcategory (e.g., reference/react/, tools-commands/nix/).
5. Write the summary and content.
6. User confirmation: Display the path of the saved file.

### Saving Project-Specific Memos

1. User provides information specific to a project.
2. Classify under `memories/projects/{project-name}/`.
3. **Create subcategories as needed**: typescript/, database/, frontend/react/, etc.
4. Create the file.
5. User confirmation: Display the path of the saved file.

### Searching Memos

1. User says "Check previous memos" or relevant memos are needed.
2. Refer to search results within Obsidian (search by keyword or tag).
3. Read and provide relevant memos.
4. Propose updates with new information if necessary.

### Organizing Memos

1. Regularly check `memories/inbox/`.
2. Move unorganized memos to the appropriate category.
3. Delete or update outdated information.
4. If categories become too complex, further subdivide (e.g., reference/ → reference/react/hooks/, reference/react/performance/).
5. Organize `memories/projects/{project-name}` upon project completion (archive or delete).
