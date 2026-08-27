---
name: astro-remark-rehype
description: Build, test, or debug remark and rehype plugins used by Astro projects. Use when work changes Markdown or HTML AST transforms, plugin registration, options, ordering, or plugin behavior inside Astro. Do not use for general Astro UI, Content Collections, MDX, or Obsidian publishing issues unless a remark or rehype plugin is the suspected boundary.
---

# Astro Remark/Rehype

Find the first incorrect boundary in the actual Markdown pipeline, then make the smallest change that fixes it. Do not assume the package manager, plugin layout, test harness, or Astro configuration shape.

## Trace the real pipeline

Before editing:

1. Read the repository instructions, package manifest, lockfile, scripts, and existing tests to learn the project's commands and conventions.
2. Find the active `astro.config.*`, the exact plugin import and registration, its options and order, the plugin implementation, and every relevant caller or test.
3. Identify the transform phase: remark operates on mdast before Markdown becomes HTML; rehype operates on hast after that conversion. Inspect the tree shape at the first boundary where observed behavior can diverge.
4. For a bug, check sibling call paths that share the transformer and fix the root cause once. Do not patch only the reported page when the same transformer serves others.

If plugin involvement is not established, stop applying this skill and continue with the appropriate Astro or frontend diagnosis.

## Implement in place

- Reuse the repository's existing plugin location, utilities, types, dependencies, and test style.
- Preserve intentional plugin ordering and metadata. Treat an order change as behavior, not cleanup.
- Add a dependency, public option, scaffold, or abstraction only when the requested behavior requires it.
- Keep pure tree transformation separate from Astro-specific registration when the existing design already exposes that seam.

## Verify by the narrowest layer

Start at the first layer that can prove the changed behavior; add later layers only when the change crosses their boundary.

1. **Pure transform**: for AST logic, run the existing focused test with representative input and assert observable mdast, hast, or rendered HTML behavior. Include the smallest edge case that would catch the reported regression.
2. **Astro integration**: when registration, options, ordering, module loading, or build behavior changed, run the project's narrowest Astro build, render, or integration check and inspect the affected generated HTML.
3. **Browser behavior**: when the result depends on CSS, client runtime, hydration, or viewport, verify the affected page in the browser and cover only the relevant viewport or interaction.

Use the repository's package manager and scripts. Do not substitute `npm`, create a fresh harness, or start a dev server when an existing test or build already proves the behavior.

## Handle suspected stale state

Do not clear `.astro` by default. First confirm that the active config imports the edited source, the current process uses the expected module, and a normal rerun or restart still shows behavior inconsistent with the source and focused checks.

Only when that evidence points to stale Astro state, identify the exact project's cache directory and the process using it. Follow the repository's cleanup command when one exists; otherwise explain the target and impact and obtain any required authorization before removing only that cache. Restart the affected process and rerun the same failing check.

## Report

State the root cause and pipeline boundary, files changed, focused verification and results, whether broader Astro or browser checks were necessary, any cache action taken, and anything left unverified.
