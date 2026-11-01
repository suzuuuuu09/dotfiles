# Authorize auto-merge with a label

## Decision

`automerge` ラベルを、同一リポジトリの非Draft PRに対する自動マージの許可とする。
Renovateは更新PRにこのラベルを付け、削除された場合は未完了の予約を解除する。
必須チェックはGitHubのブランチ保護で管理し、`required-ci` とSocketを必須、
CodeRabbitを参考とする。`main` の更新ごとにRenovateを実行する。

この判断は [ADR 0015](0015-pin-and-automate-dependency-updates.md) の
自動マージ条件と保護設定の反映手順を置き換える。GitHubへの反映と既存PRの移行は
[反映手順](../automerge-rollout.md)に従う。
