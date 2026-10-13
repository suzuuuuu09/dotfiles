# OMP Jev Auto Mode (local)

[jomatsu/pi-jev-auto-mode](https://github.com/jomatsu/pi-jev-auto-mode) v0.5.0 を OMP 向けに移植した個人用拡張。元コードは MIT ライセンス（`LICENSE`）です。

## 主な変更

- Pi の API を OMP の API に変更（`@oh-my-pi/pi-coding-agent` / `@oh-my-pi/pi-utils`）。
- Jev の判定が不確実な場合、デフォルトで `ask`。UI が使えない場合は拒否。
- OMP `eval` は、Bash を間接実行できるため拡張が有効な間は拒否。Jev に評価させて許可する方式にはしない。
- `.omp` / `.herdr` の設定ファイルを保護対象に追加。
- 確認ダイアログは対象・コマンド先頭・理由の3行に縮小。
- OMP にない Pi の `registerEntryRenderer` は使用せず、判定履歴は `appendEntry` で保持。

## セットアップ

```fish
cd ~/dotfiles/omp/extensions/jev-auto-mode
bun install
bun run check
```

Home Manager の `.config/nix/home/common/dotfiles.nix` が、`~/.omp/agent/extensions/jev-auto-mode` にディレクトリをリンクします。反映後、OMP を再起動します。インストール済みの元プラグインと自作 `jev-guard` は**同時に読み込まない**でください。

OMP 内で `/jev-auto-mode login` を実行して TypeSafe API キーを登録します。キーは `~/.omp/agent/secrets/` 配下の権限 0600 のファイルへ保存され、dotfiles に含めません。環境変数 `TYPESAFE_API_KEY` でも利用できます。

`/jev-auto-mode` で現在の状態を確認できます。

## OMP の承認設定との関係

この拡張の判定と OMP 本体の承認は**別々**です。追加承認が生じる場合があります。完全な二重承認解消は未検証です。

OMP 本体でも eval を拒否する場合の設定例（`~/.omp/agent/config.yml` 等）：

```yaml
tools:
  approval:
    eval: deny
```

通常の OMP 承認を省略する場合は、信頼できる環境で、各種保護の適用範囲を理解した上で `tools.approvalMode: yolo` を個別に検討してください。拡張の対象外ツールも無確認で動くため、このリポジトリからは自動設定しません。

## 制限・安全上の注意

- **実機検証前**の移植版です。API 互換性と Herdr 通知は未確認です。UI 通知の呼び出しを追加していますが、Herdr がそれを OS 通知へ転送する保証はありません。
- OMP のサブエージェントや他の拡張、ユーザー手動シェル実行まで強制的に閉じ込めるサンドボックスではありません。
- `bash`、`write`、`edit` の判定は元の2層ポリシー（固定ルール → Jev）を維持します。元コードの既知安全なコマンドは API に送られません。
- `write` / `edit` で cwd 内の通常ファイルは従来どおり素通りします。パスチェックは字句的であり、シンボリックリンク経由の書き込みは別途対策が必要です。
- TypeSafe の応答不能・タイムアウト・判定不能時は安全側に拒否します。
- API へはコマンド、対象パス、最近のユーザー要求などが送られます。秘密文字列の簡易マスキングはありますが完全な DLP ではありません。

## 開発

```fish
bun run typecheck
bun test
```

上流の変更を追従する場合、`src/jev/` と `src/policy.ts` を中心に diff を比較してください。OMP 接続コード (`src/extension.ts`) は独立して保守します。
