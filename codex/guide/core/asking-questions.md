# Guide for Asking Questions

Use this guide on every turn that sends a question to the user.
There are no exceptions for an interview required by a skill, the next question after receiving a user response, or a follow-up confirmation.

## Highest-Priority Format

Use the following complete format for every question, including during a multi-turn interview.
Even if the previous question used the complete format, do not omit the number, options, impacts, or rationale for the recommendation in the next one.

```text
Qk/N: 一つの判断を尋ねる質問

- A または Yes / OK: この選択肢の意味と主な影響
- B または No: この選択肢の意味と主な影響

推奨: 回答。具体的な理由。
```

It is not enough to phrase a question so it can be answered with Yes or No.
When using Yes / No / OK, explicitly state the accepted responses as option lines.

Immediately before sending a question, confirm all four of the following:

- It includes `Qk/N`.
- It states the available response options.
- It explains what each option means and its main impact.
- It states a recommended response and a specific reason.

## Numbering Consecutive Questions

Before starting an interview, count the unresolved, independent decisions identified through investigation and use that total as `N`.
If branching or additional user information changes the number of decisions, explain in one sentence why the total changed before the next question, then use the new `N` from that point onward.
Do not rewrite previous question numbers or omit `Qk/N` because `N` cannot be finalized.

## Decide Whether a Question Is Needed

Before asking a question, inspect the relevant files, configuration, tests, diff, and any necessary history.

Do not ask a question when all of the following are true; state the assumption you adopted and proceed.

- A reasonable default can be selected from the existing implementation or current conversation.
- The change is within the requested scope, safe, and reversible.
- The choice would not materially change public behavior, data, safety, permissions, or cost.

Ask only when, after investigation, a decision about the user's intent, priorities, or authority remains and the result would materially change based on the answer. Do not ask questions that can be safely progressed without an answer.
When the user or a skill explicitly requests an interview, treat asking each decision during that interview as already authorized.

## Question Format

- Ask about only one decision at a time. Use `Q1/1` even for a single question; when asking multiple decisions in sequence, use the current number, such as `Q1/N`.
- Use either A / B / C options or a format answerable with Yes / No / OK. Do not assume a free-form response.
- For A / B / C, explain what each option means and its main impact, and state the recommended option and rationale.
- For Yes / No / OK, state the operation to approve, its target, and its main impact, then state the recommended response and rationale.
- When the recommendation depends on assumptions, include them in the rationale.
- Stop work only when it cannot proceed without an answer.

### A / B / C Example

Q1/1: 保存先はどちらにしますか？

- A: ローカル保存。構成は単純ですが、単一ホスト向けです。
- B: オブジェクトストレージ。運用は増えますが、複数ホストと耐久性に向きます。
- C: 今回は設計だけに留め、実装を保留します。

推奨: 本番で複数ホストを使う前提なら B。データ耐久性をアプリケーションホストから分離できるためです。

### Yes / No / OK Example

Q1/1: 列挙した再生成可能なキャッシュだけをゴミ箱へ移動してよいですか？

- Yes / OK: 対象をゴミ箱へ移動します。復元できます。
- No: 何も変更せず、候補一覧だけを残します。

推奨: Yes。完全削除せず復元可能な方法で依頼を満たせるためです。

## After a Response

- Apply the response to the assumptions and change scope, and do not reconfirm the same decision.
- Advance the number and ask one question only when another independent decision becomes necessary.
