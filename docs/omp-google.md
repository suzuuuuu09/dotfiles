# OMPのGoogle連携

Composio Connect用のMCP設定をHome Managerで生成する。GoogleのOAuthトークンはComposio側で管理し、OMPからComposioへ接続するconsumerキーだけをSOPSで暗号化管理する。

## キーの登録

Composio Connectの「Sessions & API Key」でconsumerキー（`ck_*`）を取得する。developer projectキー（`ak_*`）とは異なる。キーをチャット、シェルの引数、Nix式へ貼り付けない。

ローカルで`sops .config/nix/secrets/secrets.yaml`を開き、`composio_consumer_api_key`へキーを登録する。保存後のファイルはSOPS暗号文とし、平文ファイルを追加しない。

`.config/nix/home/common/sops.nix`の`sops.secrets`へ次の宣言を追加する。

```nix
composio_consumer_api_key = { };
```

キーと宣言を揃えてから、通常のNix設定適用を行う。この宣言がない間はMCP設定を生成しないため、今回の変更だけで未登録の秘密によるactivation失敗は発生しない。

生成先は`~/.omp/agent/mcp.json`。ヘッダーには実行時の秘密ファイルを読むコマンドだけが入り、復号値はNix storeへ含まれない。既存ファイルがある場合は内容を確認し、必要なMCP設定を統合してから適用する。名前付きOMPプロファイルは別の設定ディレクトリを使うため、この設定は既定プロファイル向け。

## 有効化前の検証

**Composioは既定で無効。現時点ではGoogle連携の完成条件を満たしていない。** Google API・OAuth・セッション管理の独自実装は追加しない。

- Connectの実際のツール定義で、複数Google接続と任意の別名による選択を確認する。Google Superが必要なサービスを満たせれば統合接続を優先し、サービス別接続なら同じ名前とGoogleアカウントの一致を確認する。
- 書き込みは、接続が一つでも対象の別名・接続IDを必須にする。`COMPOSIO_MULTI_EXECUTE_TOOL`だけでなくremote workbench・bashなどの迂回経路も確認する。OMPへの指示だけでは有効化しない。
- 読み取り専用で先行利用する場合も、OAuth権限やサービス側のツール制限で書き込みを防げることを確認する。
- 利用料金と付与権限を確認し、Googleアカウントの認可はブラウザでユーザーが行う。Google OAuthトークンはSOPSにも登録しない。

検証後にNix側の`enabled`を変更する。生成ファイルの直接編集や`/mcp enable`は安全条件の代わりにならない。検証のため一時的に接続する場合は、Googleアカウントを接続せずツール定義の読み取りだけを行う。

新しいPCではSOPSのage秘密鍵を別途配置し、Nix設定を適用する。Composio側のGoogle接続は再利用し、失効や権限不足があれば再認可する。

公式資料: [Composio Connect認証](https://docs.composio.dev/kb/guide/consumer-project-boundaries-and-auth-selection)、[OMP 18.3.2 MCP設定](https://github.com/can1357/oh-my-pi/blob/v18.3.2/docs/mcp-config.md)。設計判断は[調査メモ](research/omp-google.md)に記録する。

設定の検証はリポジトリ直下で実行する。秘密値は不要。

```sh
nix eval --json --impure --expr 'import ./.config/nix/tests/omp-composio.nix { lib = (builtins.getFlake ("git+file://" + toString ./.)).inputs.nixpkgs.lib; }'
```
