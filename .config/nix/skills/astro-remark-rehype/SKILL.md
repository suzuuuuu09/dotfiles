---
name: astro-remark-rehype
description: |
  Use this skill when the user is building, testing, or debugging remark or rehype plugins for an Astro project. Trigger on phrases like "astro remark plugin", "rehype plugin", "astro markdown plugin", "create remark plugin", or when the user asks how to verify a plugin in an Astro dev server. Provide step-by-step instructions for implementation, testing, and verification including the recommended dev-server cache-clearing workflow.
compatibility:
  required: [node, npm, astro]
  optional: [pnpm, bun]
---

# astro-remark-rehype

This skill helps create, test, and verify remark/rehype plugins for Astro projects. It includes:

- Guidance for plugin structure and Astro integration
- Development and debugging checklist
- A repeatable verification flow to confirm the plugin is active in an Astro dev server
- Example test prompts and eval file structure for rule-based verification


## When to use

Invoke this skill when you are:

- Implementing a new remark or rehype plugin for an Astro site
- Updating an existing plugin and wanting a reproducible verification workflow
- Seeing stale behavior in the Astro dev server after plugin changes


## Quick verification workflow (3-step)

1. Stop the Astro dev server (e.g., Ctrl+C in the terminal where it's running).
2. Remove Astro's cache folder to clear compiled artifacts: delete the .astro directory in the project root (e.g., `rm -rf .astro`).
3. Restart the dev server (e.g., `npm run dev`) and verify the plugin behavior in the browser or by inspecting the generated output files.

Always follow this sequence whenever a plugin's behavior doesn't reflect recent changes.


## Recommended plugin project layout

- my-plugin/
  - package.json
  - index.js (or index.ts) — exports the plugin function
  - README.md
  - tests/ — unit tests for transformer behavior

Export the plugin as a Node-compatible module and document its options.


## Astro integration example

In astro.config.mjs add the plugin to your markdown pipeline, for example:

```js
import myRemark from './path/to/my-plugin'

export default {
  markdown: {
    remarkPlugins: [myRemark({ /* options */ })],
    rehypePlugins: []
  }
}
```

If using a package, install it and import the package name instead of a relative path.


## Development tips

- Write unit tests for pure remark/rehype transforms using unified and remark/rehype test harnesses.
- Use console logging sparingly in transforms; prefer writing deterministic test assertions for functional checks.
- When testing integration with Astro, prefer the 3-step cache-clear restart sequence above rather than relying on hot-reload for plugin changes.


## Test/eval structure for the skill-creator workflow

Create a workspace alongside the skill to run evaluations:

```
<skill-workspace>/iteration-1/
  eval-01-without_skill/
  eval-01-with_skill/
  eval_metadata.json
```

Each eval metadata should include the prompt and files to feed the test harness.


## Verification checklist (manual)

- [ ] Stop dev server
- [ ] Remove .astro folder
- [ ] Start dev server
- [ ] Load page that uses the markdown
- [ ] Confirm plugin effects (visual or generated HTML)


## Example test prompts (for evals/evals.json)

1. "Add a custom admonition parser that turns lines starting with 'NOTE:' into a div with class 'admonition note'." — expected: markdown to HTML contains <div class="admonition note"> with the content.

2. "Rewrite external links to add rel=\"noopener noreferrer\" and target=\"_blank\"" — expected: anchor tags for external links include those attributes.


## Troubleshooting

- If changes are not visible after restart, confirm:
  - You're editing the plugin file that Astro imports (relative path vs installed package)
  - Node's module cache isn't shadowing (if linking via npm link, reinstall or use file: in package.json)
  - There are no build-time errors in the server console


## Automation suggestions

- Add an npm script to fully restart the dev server and clear cache:

```json
// package.json scripts
"dev:fresh": "rm -rf .astro && npm run dev"
```

- Add unit tests that run without Astro using unified test helpers.


## Files to generate for skill-creator evals

- evals/evals.json — contains test prompts and expected outputs (no assertions required initially)
- workspace/iteration-1/<eval-name>/{with_skill,without_skill}/outputs/
- eval_metadata.json for each eval


## Closing

If you want, generate SKILL.json packaging, create example unit tests, or populate evals/evals.json with the three sample prompts above. Tell me which next step to take.
