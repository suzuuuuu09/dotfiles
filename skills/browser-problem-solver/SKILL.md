---
name: browser-problem-solver
description: Browser-based problem solving for quizzes, confirmation tests, worksheets, and other form-driven tasks. Use when the user asks to solve questions shown in a browser, read on-screen prompts, reference linked materials or local study files, write out all answers in chat, fill answers into an existing logged-in session, or navigate multi-page attempts before submission.
---

# Browser Problem Solver

## Mode Selection

| Situation | Mode |
| --- | --- |
| User says "答えだけ", "write out all answers", or provides copied text, screenshots, or a transcript | `answer-only` |
| User asks to type, select, save, advance pages, or preserve progress in a live logged-in session | `browser-entry` |
| The request is ambiguous, and an action might change page state | default to `answer-only` and ask before changing anything |

If the user explicitly asks for browser entry, use `browser-entry`. Otherwise, prefer the least stateful mode that satisfies the request.
If the user wants browser entry but only static material is available, ask for a live browser session instead of pretending to enter answers.
When `browser-entry` is selected and a live browser is available, use Computer Use to perform the actual clicks, typing, saving, and page changes instead of leaving the work in chat.

## Critical Rules

- In `answer-only`, do not change page state, trigger auto-save, or submit anything.
- Never final-submit, hand in, send, or confirm a step that transmits work to a third party without explicit user confirmation after reviewing the summary screen.
- In `browser-entry`, verify that the entered answer is visible and saved before moving to the next page or question.
- In `browser-entry`, drive the live browser with Computer Use so the answers are actually entered into the session.
- If the needed source is missing or the question is still ambiguous after reading visible instructions, linked materials, and local study files, stop instead of guessing. If a stem, option label, or referenced fact is missing, name the missing piece before stopping.
- Return answers using the page's visible numbering or labels exactly.

## Workflow

1. Start from the active browser session first and keep the current login or profile if it is already signed in.
2. If the task is provided as copied page text, screenshots, or a transcript instead of a live browser, treat that material as read-only source context and default to `answer-only` unless the user explicitly asks for page entry.
3. Read the full question, choices, numbering, and nearby instructions before answering.
4. Gather supporting material from the page, linked documents, and local study files before guessing.
5. Follow source priority in this order:
   1. Visible question text and page instructions.
   2. Linked documents, attachments, and referenced materials.
   3. Local study files provided with the task.
   4. General knowledge.
6. Keep a short answer map for multi-page attempts so earlier responses stay consistent.
7. In `answer-only` mode, you may navigate to later pages or open linked materials that are needed for reading, but do not select, type, save, submit, or trigger any action that could persist progress.
8. In `browser-entry` mode, solve one page or item at a time, verify the answer is reflected in the control, verify the saved state or persistence, then move on.
9. If the needed source is missing or the question is ambiguous after reading all available materials, stop and ask for help instead of inventing an answer.
10. Before any final submit, hand in, send, or confirm action that transmits work to a third party, review the summary screen and confirm the user wants to send the work.

## Browser Tactics

- Prefer the smallest interaction that preserves progress: choose, fill, save, then advance.
- Use local study materials as the source of truth when the browser question matches them.
- Continue from the open tab rather than forcing a new login when the user asks to keep the current session.
- When the user asks to "write out all answers", do not force browser input; produce a clean answer list first.
- When answers are returned in chat, mirror the visible numbering or labels so the user can paste them back easily.
- For `answer-only`, use a compact list with just the answer token unless the user asked for explanation, for example `1. a`, `2. e`, or `Q3: c`.
- Keep the answer map in a simple structure such as `Q1 -> b`, `Q2 -> e`, and update it before moving to the next page.
- If the browser blocks progress with a CAPTCHA, permission prompt, login or MFA screen, safety interstitial, or unexpected confirmation dialog, hand the step back to the user.

## References

- `references/operating-rules.md`
- `references/evaluation-scenarios.md`
