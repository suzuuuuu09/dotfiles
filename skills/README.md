# Local Agent Skills

This directory contains custom Agent Skills developed for this repository.
For detailed operation specifications of each skill, please refer to the respective `SKILL.md` files.

## Skill List

### Web

| Skill | Description |
| --- | --- |
| [`astro-remark-rehype`](web/astro-remark-rehype) | Builds, tests, and debugs remark/rehype plugins used by Astro projects. |
| [`panda-css`](web/panda-css) | Chooses the appropriate Panda CSS styling API for UI implementation and refactoring. |

### General

| Skill | Description |
| --- | --- |
| [`audit-agent-guidance`](audit-agent-guidance) | Audits effective agent instructions, skill selection, activation evidence, and dependencies. |
| [`browser-problem-solver`](browser-problem-solver) | Assists in solving browser-related issues and in creating/inputting solutions. |
| [`deepseek-delegate`](deepseek-delegate) | Delegates a bounded coding task to OpenCode with DeepSeek Free; Codex reviews and verifies the result. |
| [`design-safe-ai-decisions`](design-safe-ai-decisions) | Supports evaluation and operational design of AI-assisted decision-making systems. |
| [`nix-environment-doctor`](nix-environment-doctor) | Diagnoses command provenance, environment differences, and Nix activation failures. |
| [`prune-redundant-tests`](prune-redundant-tests) | Reviews existing tests for overlapping regression coverage and preserves independent guarantees. |
| [`run-missing-cli`](run-missing-cli) | Guides temporary execution of missing CLIs without permanent installation. |
| [`storage-cleanup`](storage-cleanup) | Audits and cleans shared developer caches and checks Nix garbage collection. |

## Directory Structure

```text
<skill-name>/
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
