# 自動マージ設定の反映

専用workflowの変更とGitHub側の設定を別々に反映する。
ラベルの作成・付け替えは不要である。

1. 変更を `main` へ反映し、CIと `Bot: Merge Renovate PR` の実行結果を確認する。
   GitHub Actionsのポリシーで `pull_request_target` が制限される場合は、
   [GitHubの仕様](https://docs.github.com/en/actions/reference/security/securely-using-pull_request_target)
   に従い、対象workflowに限定した許可を設定する。
   `.github/automerge-actions-policy.json` に対象workflowのポリシーを置いている。

2. リポジトリの自動マージ許可と `main` の保護設定を確認する。

   ```sh
   gh api repos/suzuuuuu09/dotfiles --jq '.allow_auto_merge'
   gh api repos/suzuuuuu09/dotfiles/branches/main/protection \
     --jq '{strict: .required_status_checks.strict, checks: .required_status_checks.checks, admins: .enforce_admins.enabled}'
   ```

   自動マージを有効にし、必須チェックを `required-ci` とSocketの2チェックにする。
   App IDは `.github/main-protection.json` を参照する。
   `strict` と管理者への適用を有効にし、既存の追加設定は保持する。
   CodeRabbitが必須に残っていれば、それだけを外す。
   条件を満たす予約済みPRが、この設定変更でマージされる場合がある。

   ```sh
   gh api --method DELETE \
     repos/suzuuuuu09/dotfiles/branches/main/protection/required_status_checks/contexts \
     -f 'contexts[]=CodeRabbit'
   ```

3. 既存のRenovate PRの予約状態を確認する。

   ```sh
   gh pr list --repo suzuuuuu09/dotfiles --state open \
     --author 'app/suzuuuuu09-renovate' \
     --json number,title,autoMergeRequest
   ```

   予約済みなら追加操作は不要である。未予約のPRは、Renovateによる次の更新で
   workflowが実行された後に確認する。最新化と必須チェックの成功を待って
   GitHubがマージする。PRごとの保護設定照合は行わない。

自動マージを止める場合は、GitHub画面または `gh pr merge <番号> --disable-auto` を使う。
ただし、PR更新などでworkflowが再実行されると再び予約され得る。
