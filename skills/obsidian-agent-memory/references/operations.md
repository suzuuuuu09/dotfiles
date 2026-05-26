# Note Operations: Saving, Searching, and Managing

This document explains how to save, search, manage, and troubleshoot your notes.

## Table of Contents

1. [Saving Notes](#saving-notes)
2. [Searching Notes](#searching-notes)
3. [Managing Notes](#managing-notes)
4. [Troubleshooting](#troubleshooting)

## Saving Notes

### Basic Workflow

1. **Determine the type of note**
   - Project-specific? → `memories/projects/{project-name}/`
   - Reusable across multiple projects? → Save to a general-purpose folder

2. **For general notes, choose a category**
   - Technical findings → `learning/`
   - Solutions → `reference/`
   - Recurring issues → `troubleshooting/`
   - Design patterns → `architecture/`
   - Commands/Scripts → `tools-commands/`
   - Unknown → `inbox/` (sort later)
   - **Need a new category?** Feel free to create one.

3. **Create the file**

```bash
# Example of a general reference (existing category)
mkdir -p ~/Documents/Vault/memories/reference/
cat > ~/Documents/Vault/memories/reference/cors-error-fix.md << 'EOF'
---
summary: "CORS error resolution and configuration guide"
created: 2025-01-15
tags: [cors, http, troubleshooting]
---

# CORS Error Resolution

## Problem
Request fails with a CORS error...
EOF

# Example of a general reference (creating a new category)
mkdir -p ~/Documents/Vault/memories/reference/nix-darwin/
cat > ~/Documents/Vault/memories/reference/nix-darwin/home-manager-setup.md << 'EOF'
---
summary: "Dotfiles management and system configuration with home-manager"
created: 2025-01-15
tags: [nix, darwin, configuration]
---

# home-manager Setup Guide

Configuration management using home-manager...
EOF

# Example of a learning note
mkdir -p ~/Documents/Vault/memories/learning/
cat > ~/Documents/Vault/memories/learning/nodejs-eventloop.md << 'EOF'
---
summary: "Node.js Event Loop: microtasks vs macrotasks"
created: 2025-01-15
status: resolved
tags: [nodejs, eventloop, javascript]
---

# Node.js Event Loop

Microtasks (Promises) are executed before macrotasks (setTimeout)...
EOF

# Example of a project-specific note (basic structure)
mkdir -p ~/Documents/Vault/memories/projects/my-app/
cat > ~/Documents/Vault/memories/projects/my-app/authentication-setup.md << 'EOF'
---
summary: "OAuth2 + JWT authentication implementation for my-app"
created: 2025-01-15
status: in-progress
tags: [auth, my-app]
---

# Authentication Setup for my-app

About the authentication implementation specific to this project...
EOF

# Example of a project-specific note (sub-category)
mkdir -p ~/Documents/Vault/memories/projects/my-app/frontend/react/
cat > ~/Documents/Vault/memories/projects/my-app/frontend/react/component-patterns.md << 'EOF'
---
summary: "React component design patterns for my-app"
created: 2025-01-15
tags: [react, components, my-app]
---

# React Component Patterns for my-app

Component design used in this project...
EOF

# Example of tools-commands (new category)
mkdir -p ~/Documents/Vault/memories/tools-commands/nix/
cat > ~/Documents/Vault/memories/tools-commands/nix/flake-commands.md << 'EOF'
---
summary: "Commonly used Nix flake commands"
created: 2025-01-15
tags: [nix, flake, cli]
---

# Nix Flake Commands Cheatsheet

Commands necessary for flake development...
EOF
```

### File Naming Conventions

- Use kebab-case: `my-feature-name.md`
- Make it clear and descriptive of the content
- No need for dates (recorded in frontmatter)

## Searching Notes

### Searching within Obsidian

Use Obsidian's built-in search features:

1. **Quick Open** (`Cmd/Ctrl+P`): Search by file name
2. **Global Search** (`Cmd/Ctrl+Shift+F`): Full-text search
3. **Link suggestions**: Discover related files using `[[`

### Searching via Command Line

For manual searching (reference):

```bash
# Check the summary field
grep -r "^summary:" ~/Documents/Vault/memories/ | head -20

# Search by keyword
grep -r "keyword" ~/Documents/Vault/memories/ -i

# Search for specific tags
grep -r "tags:.*keyword" ~/Documents/Vault/memories/ -i

# Search within a specific category
grep -r "keyword" ~/Documents/Vault/memories/reference/nix-darwin/ -i
```

## Managing Notes

### Updating

When information changes, update the content and add an `updated` field to the frontmatter:

```yaml
---
summary: "Updated summary"
created: 2025-01-15
updated: 2025-01-20
status: resolved
---
```

### Deleting

Delete notes that are no longer needed. Clean up empty folders as well.

### Merging

Merge related notes on the same topic as necessary:

```bash
# After merging files, delete the old file
rm ~/Documents/Vault/memories/category/old-file.md
```

### Reorganizing

As your knowledge base grows, move notes into better categories:

```bash
# Example 1: From inbox to an appropriate category
mv ~/Documents/Vault/memories/inbox/note.md \
   ~/Documents/Vault/memories/reference/note.md

# Example 2: Create a new sub-category and move files
mkdir -p ~/Documents/Vault/memories/reference/react-hooks/
mv ~/Documents/Vault/memories/reference/hooks-*.md \
   ~/Documents/Vault/memories/reference/react-hooks/
```

## Troubleshooting

### Cannot access Vault

```bash
# Check the path
ls -la ~/Documents/Vault/

# Create memory folders
mkdir -p ~/Documents/Vault/memories/{projects,reference,learning,troubleshooting,architecture,tools-commands,inbox}
```

### File name conflicts

To avoid overwriting existing files, confirm with the user before saving.

### Cannot find notes

Use the search function within Obsidian or check if they are categorized by tags. Please verify if they are located in a specific subcategory.

### Folder structure has become complex

Periodically review your knowledge base and consider whether to split it into smaller parts or merge them. You can maintain organization by creating new subcategories as needed.
