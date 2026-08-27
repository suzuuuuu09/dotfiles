---
name: panda-css
description: Choose the appropriate Panda CSS styling API when implementing or refactoring UI with css, cva, sva, config recipes, slot recipes, and layout patterns.
---

# Panda CSS API Selection

Choose the smallest existing abstraction that clearly expresses the UI's intent.
Project conventions and existing recipes or patterns take precedence.

## Decision Tree

```text
Need styles
│
├─ Existing recipe or pattern fits? → Reuse it
├─ Meaningful layout structure? → Consider a Pattern
└─ Component or visual styles
   ├─ No stable variant API → css()
   └─ Has meaningful variants
      ├─ One class or primary element → cva() / Config Recipe
      └─ Multiple slots change together → sva() / Config Slot Recipe
```

Use this as guidance, not a mechanical rule.
If an abstraction adds indirection without clarifying intent or reuse, stay one level lower.

## API Choices

| API | Use when | Prefer something else when |
| --- | --- | --- |
| `css()` | Styles are local, one-off, or do not define a stable variant API; small local conditionals are fine | Callers need named variants, several slots change together, or a Pattern expresses the layout better |
| Pattern | The layout has recognizable structure and the Pattern's props and defaults match it | Flex or grid is only an implementation detail inside broader component styles |
| `cva()` | A local component exposes named visual axes such as `size` or `tone` that mostly produce one class | The recipe belongs to the shared design system or variants coordinate multiple slots |
| Config Recipe | A single-class recipe is shared project-wide, shipped in a preset, or owned by the design system | The recipe is local and config registration would add ceremony |
| `sva()` | A local component has multiple named slots whose styles change together under the same variants | It merely has multiple child elements without cross-slot variant coupling |
| Config Slot Recipe | A shared compound component needs a stable slot and variant contract in the design system | The component is local or a single class is enough |

## Pattern Choices

| Pattern | Use when |
| --- | --- |
| `stack` | Items form an ordered row or column with consistent spacing |
| `hstack` | Items form a row and should be vertically centered |
| `vstack` | Items form a column and should be horizontally centered; use `stack` for a plain column |
| `flex` | The layout needs general flex behavior such as wrap, basis, grow, or shrink |
| `grid` / `gridItem` | The layout is two-dimensional or uses columns, minimum child width, or spans |
| `center` | Centering content is the layout's primary intent |
| `wrap` | Items should preserve spacing while wrapping |
| `container` | Content needs the project's standard centered max-width container |
| `cq` | The element establishes a container-query context |
| `visuallyHidden` | Content must be visually hidden while remaining available to assistive technology |

Use other built-in or custom Patterns when their named structure and constraints match the layout.
Do not convert every `display: flex` to `stack`; Pattern selection depends on intent, props, and defaults.
Do not introduce `cva()` for every conditional or `sva()` for every component with children.
