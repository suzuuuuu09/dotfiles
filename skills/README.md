# Local Agent Skills

This directory contains custom Agent Skills developed for this repository.
For detailed operation specifications of each skill, please refer to the respective `SKILL.md` files.

## Skill List

| Skill | Description |
| --- | --- |
| [`astro-remark-rehype`](astro-remark-rehype) | Supports development, testing, and validation of Astro's remark/rehype plugin implementations. |
| [`browser-problem-solver`](browser-problem-solver) | Assists in solving browser-related issues and in creating/inputting solutions. |
| [`design-safe-ai-decisions`](design-safe-ai-decisions) | Supports evaluation and operational design of AI-assisted decision-making systems. |
| [`obsidian-agent-memory`](obsidian-agent-memory) | Manages retrieval, organization, and rewriting of agent memories using Obsidian. |
| [`request-framework`](request-framework) | Organizes requests by purpose, constraints, outputs, and approval boundaries. |
| [`run-missing-cli`](run-missing-cli) | Guides temporary execution of missing CLIs without permanent installation. |

## Directory Structure

```text
skills/
├── README.md
└── <skill-name>/
    ├── SKILL.md              # Required: Skill implementation and activation conditions
    ├── agents/openai.yaml    # Optional: Agent metadata
    └── references/           # Optional: Detailed procedures or evaluation materials
```

The `name` field in the frontmatter of `SKILL.md` serves as the skill's unique identifier.
Ensure the directory name and `name` field are consistent.

## Installation and Configuration

Local skills are registered as Home Manager's `personal` source and placed in `~/.agents/skills`.
Registration details are managed in [.config/nix/home/common/agent-skills.nix](../.config/nix/home/common/agent-skills.nix).

To apply changes, perform the standard Nix rebuild for the affected environment.

```bash
# macOS
sudo darwin-rebuild switch --flake .#suzuMac

# NixOS-WSL
sudo nixos-rebuild switch --flake .#suzuWsl
```

After applying changes, you can verify that the skill has been placed in `~/.agents/skills/<skill-name>`.
Skills obtained from external sources or explicitly selected skills are managed and configured in the respective source definitions managed by `agent-skills.nix`.

## When Adding New Skills

1. Create `skills/<skill-name>/SKILL.md`.
2. Include `name` in the frontmatter along with a brief `description` specifying activation conditions.
3. Separate detailed procedures or evaluation materials in `references/` and link from `SKILL.md`.
4. Add auxiliary files like `agents/openai.yaml` only when necessary.
5. Run `nix flake check` and perform the standard Nix rebuild for the affected environment to verify changes.

Skill descriptions should include "when to use" and "what not to do", ensuring activation conditions do not overlap with other skills.
