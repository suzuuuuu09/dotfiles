# 自動マージ設定の反映

この手順は、ラベルによる自動マージをGitHubへ反映するときに一度だけ行う。
実行前に対象リポジトリの現在の設定を確認する。

1. `automerge` ラベルを作成する。既に存在する場合は用途を確認する。

   ```sh
   gh label create automerge --repo suzuuuuu09/dotfiles \
     --color 2da44e --description '必須チェック成功後の自動マージを許可'
   ```

2. GitHub Actionsの既存ポリシーを確認する。公開リポジトリでは、対象となる
   `pull_request_target` の既定制限が2026年12月2日に強制される予定である。
   制限の対象となる場合は、マージworkflowだけを対象とするポリシーを作成し、
   Policy insightsで実効結果を確認する。
   [GitHubの仕様](https://docs.github.com/en/actions/reference/security/securely-using-pull_request_target)

   ```sh
   gh api repos/suzuuuuu09/dotfiles/actions/policies
   gh api --method POST repos/suzuuuuu09/dotfiles/actions/policies \
     --input .github/automerge-actions-policy.json
   ```

3. この変更を `main` へ反映し、CIとマージworkflowの実行結果を確認する。
   ラベル解除時は、GitHubがマージを完了する前であれば予約が解除される。
   ラベル解除とマージが同時に進む場合、イベント処理前にマージされる可能性がある。
   同じPRの待機中イベントが100件に達すると、以降の実行はGitHubにより取り消される。

4. 既存のRenovate PRを一覧し、各PRに `automerge` を付け、予約状態を確認する。
   新規PRにはRenovateが付与する。手動でラベルを外した後に、この付与を再実行しない。

   ```sh
   gh api --paginate 'repos/suzuuuuu09/dotfiles/pulls?state=open&per_page=100' \
     --jq '.[] | select(.user.login == "suzuuuuu09-renovate[bot]" and .head.repo.full_name == "suzuuuuu09/dotfiles") | .number'
   gh pr edit <番号> --repo suzuuuuu09/dotfiles --add-label automerge
   gh pr view <番号> --repo suzuuuuu09/dotfiles --json autoMergeRequest,state
   ```

   ラベルが既に付いている場合、付け直してもイベントは発生しない。
   予約が確認できない場合はworkflowの実行結果とPRの状態を確認する。

5. `main` の必須チェックからCodeRabbitだけを外し、残りのチェック・App ID・
   `strict`・管理者への適用を確認する。CodeRabbitを外すと、ほかの必須条件を
   満たした予約済みPRがマージされる場合がある。

   ```sh
   gh api --method DELETE \
     repos/suzuuuuu09/dotfiles/branches/main/protection/required_status_checks/contexts \
     -f 'contexts[]=CodeRabbit'
   gh api repos/suzuuuuu09/dotfiles/branches/main/protection \
     --jq '{strict: .required_status_checks.strict, checks: .required_status_checks.checks, admins: .enforce_admins.enabled}'
   ```

必須チェックは `required-ci` とSocketの2チェックである。宣言するApp IDは
`.github/main-protection.json` を参照する。GitHub側に追加の必須チェックがある
場合は、その設定も保持する。
