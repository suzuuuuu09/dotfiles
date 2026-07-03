---
name: browser-problem-solver
description: Browser-based problem solving for quizzes, confirmation tests, worksheets, and other form-driven tasks. Use when the user asks to solve questions shown in a browser, read on-screen prompts, reference linked materials or local study files, write out all answers in chat, fill answers into an existing logged-in session, or navigate multi-page attempts before submission.
---

# Browser Problem Solver

## Workflow

1. Start from the active browser session first and keep the current login or profile if it is already signed in. If the task is provided as copied page text, screenshots, or a transcript instead of a live browser, treat that material as read-only source context and default to `answer-only` unless the user asks for page entry.
2. Decide the operating mode early:
   - `answer-only`: solve the questions and write out the answers in chat without changing the page unless the user asks.
   - `browser-entry`: solve the questions and enter the answers into the page while preserving progress.
3. Read the full question, choices, numbering, and nearby instructions before answering.
4. Gather supporting material from the page, linked documents, and local study files before guessing.
5. Match the required format exactly for free-text answers, including punctuation, units, and character set.
6. Keep a short answer map for multi-page attempts so earlier responses stay consistent.
7. In `answer-only` mode, you may navigate to later pages or open linked materials that are needed for reading, but avoid any action that edits page state, triggers auto-save, or submits work; return the answers in the same order and labeling the page uses whenever possible.
8. In `browser-entry` mode, solve one page or item at a time, and confirm each answer is saved before moving on.
9. If the needed source is missing or the question is ambiguous, pause and ask for help instead of inventing an answer.
10. Before a final submit action, review the summary screen and confirm the user wants to send the work if the action will transmit data to a third party.

## Browser Tactics

- Prefer the smallest interaction that preserves progress: choose, fill, save, then advance.
- Use local study materials as the source of truth when the browser question matches them.
- Continue from the open tab rather than forcing a new login when the user asks to keep the current session.
- When the user asks to "write out all answers", do not force browser input; produce a clean answer list first.
- When answers are returned in chat, mirror the visible numbering or labels so the user can paste them back easily.
- If the browser blocks progress with a CAPTCHA, permission prompt, or safety interstitial, hand the step back to the user.
