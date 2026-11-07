# Renovate PRの自動マージをGitHubに任せる

## Decision

Renovateは更新PRの作成とrebaseを担当し、自身の自動マージは無効にする。
専用workflowは、Renovate Appが作成した同一リポジトリ・main向け・非DraftのPRを対象に、
既存GitHub Appのトークンで `gh pr merge --auto --squash --match-head-commit` を実行する。
PRコードはcheckout・実行しない。

変更ファイルに応じたCI選択と、結果を集約する `required-ci` は維持する。
`required-ci` とSocketの2チェックを必須とし、CodeRabbitやその他の任意チェックは待たない。
保護設定は適用・変更時に確認し、PRごとの照合は省く。GitHubがマージ時に必須条件を強制する。
保護設定が後から緩められた場合に、workflow自身が検知して予約を拒否する機能は持たない。

ラベルによる許可・取り消しと、手動PRへの自動マージ許可は扱わない。
これらを省くことで、ラベル管理用スクリプトとイベント待ち行列の管理を不要にする。
停止にはGitHub標準の自動マージ解除を使う。ただし、解除後のPR更新でworkflowが
再実行されると再び予約され得る。PR単位の永続的な除外機能は追加しない。

strictによる最新化必須、管理者への保護適用、Renovateの日次・手動実行は維持する。
`main` の更新ごとにもRenovateを実行し、残るPRのrebaseを促す。

この判断は、以前のラベル方式と [ADR 0015](0015-pin-and-automate-dependency-updates.md) の
自動マージ条件・PRごとの保護設定照合を置き換える。
GitHubへの反映は [反映手順](../automerge-rollout.md)に従う。
コードの変更だけでは、既存のGitHub設定は変更されない。
