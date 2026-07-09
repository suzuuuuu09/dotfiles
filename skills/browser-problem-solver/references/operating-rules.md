# Operating Rules

This reference expands the short rules in `SKILL.md` with concrete checks that should be followed during browser tasks.

## Browser-entry verification

Use the smallest safe action:

1. Enter or select one answer.
2. Verify the control reflects the answer immediately.
3. Verify the page saved the change.
4. If the site does not show an explicit saved indicator, confirm persistence by returning to the item, switching pages, or refreshing in a way that does not lose progress.
5. Only then move to the next item.

If the save state cannot be confirmed, do not advance and do not guess that it worked.

## Answer map

Keep a compact map for multi-page attempts:

```text
Q1 -> b
Q2 -> e
Q3 -> c
```

Update the map as soon as an answer is decided so later pages stay consistent with earlier pages.

## Source priority

1. Visible question text and page instructions.
2. Linked documents, attachments, and referenced materials.
3. Local study files provided with the task.
4. General knowledge.

General knowledge can fill gaps, but it must not override any higher-priority source.

## Blocked states

Stop and hand the step back to the user when any of these appear:

- CAPTCHA
- Login or MFA prompt that requires user credentials
- Permission prompt or OS/browser safety interstitial
- Unexpected confirmation dialog for a potentially destructive or final action

Do not work around these prompts inside the agent.

## Output format

- For `answer-only`, return answers in the same numbering or labels the page uses.
- For multiple-choice questions, return the visible option label or letter, not a paraphrase.
- For free-text answers, preserve punctuation, units, and character set exactly.
- If the page is missing required information, report the gap instead of improvising a response.
- Compact example for `answer-only`:
  - `1. a`
  - `2. e`
  - `3. c`
- Example answer-only reply: `1. a`, `2. e`, `Q3: c`.
- If a stem, label, or option is missing from the available material, say which piece is missing and stop.
