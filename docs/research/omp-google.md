# OMPからのGoogle連携

## 確定した要件

- Googleアカウントを複数接続し、ユーザーが決める任意名で指定する。
- NixはOMPと秘密ではない連携設定を管理する。平文の認証情報やGoogle OAuthトークンはdotfilesやNix storeに含めない。
- 自前のGoogle OAuth ClientやGoogle API実装を避け、既存のOAuth・MCP機能を優先する。
- 外部サービスがGoogleの認証状態と要求されたデータを扱うことを許容する（インタビューQ1: A）。提供サービスの採用は未決定。
- OMPから連携サービスへの接続資格情報は、dotfiles外のOMPローカル状態に保存してよい（インタビューQ2: A）。Googleのトークンは連携サービス側が管理する。
- Composioを採用する場合、そのAPIキーはSOPSで暗号化管理する予定。暗号化されたキーのGit管理は許容し、復号された値は実行時の秘密ファイルにだけ置く。これは初期要件の「外部サービスの認証情報をdotfilesへ保存しない」に対する明示的な例外で、Google OAuthトークンには適用しない。
- 同じGoogleアカウントの各サービス接続に、同じ任意名をそれぞれ付ける運用を許容する（インタビューQ3: A）。初回設定時に接続先のGoogleアカウントが一致することを確認し、全サービスを束ねる独自管理機構は求めない。
- 書き込みは対象の別名・接続IDを仕組みとして必須にする（インタビューQ4: A）。OMPへの指示だけでは要件を満たさない。既存機能で強制できなければ書き込み対応を保留する。

## 調査結果と未検証事項

- 現在インストールされているOMPは18.3.2。この版の公式資料でHTTP MCPとOAuthへの対応を確認した。Composioとの実接続は未検証。
- [OMP 18.3.2 MCP設定](https://github.com/can1357/oh-my-pi/blob/v18.3.2/docs/mcp-config.md): 接続先のみの定義ではOAuth資格情報を設定と分離してauth storageに保持する。同一接続先を別名のMCPとして登録するだけでは重複排除される。
- [Composio Connect](https://docs.composio.dev/docs/composio-connect): OAuth対応MCPクライアント向けの接続先は`https://connect.composio.dev/mcp`。
- [Composioの複数接続](https://docs.composio.dev/docs/authentication/managing-multiple-connected-accounts): 接続のaliasと明示選択を提供する。ただしSDKの機能が共有Connect MCPでも同様に利用できるかは未検証。aliasはサービスごとの接続に付くため、Googleアカウント全体の名前と同一視しない。
- Google側の認証状態と、OMPから連携サービスへの認証状態は別物。後者のローカル保存は許容済み。実際の保存先がGit・Nix storeに含まれないことは実装時に検証する。
- アカウント未指定時の書き込み拒否、Gmail・Calendar・Drive・Docs・Sheetsの実接続と権限、利用料金は未検証。

## 追加調査

- [Google Super](https://docs.composio.dev/kb/guide/toolkits-googlesuper)はGoogle Workspaceの複数サービスを一つの接続で扱う候補。実際に利用できる操作は付与された権限に依存する。サービスごとに同じ名前を付ける運用は許容済みだが、統合接続で満たせればそちらを優先できる。
- [実行APIの仕様](https://docs.composio.dev/reference/v3/api-reference/tool-router/postToolRouterSessionBySessionIdExecute)では、単一接続時に`account`を省略すると既定接続が使われる。メタツールには独自の選択フィールドがあり、共有Connect MCPの全書き込みで省略を拒否できることは未確認。
- SDKの`requireExplicitSelection`は複数の有効接続がある場合の必須化であり、単一接続時を含むQ4の条件を満たす根拠にはならない。
- [Connectの認証方式](https://docs.composio.dev/kb/guide/consumer-project-boundaries-and-auth-selection): 共有Connect MCPのAPIキー方式はconsumerキー（`ck_*`）を`x-consumer-api-key`ヘッダーで送る。developer projectキー（`ak_*`）とは別物である。
- OMP 18.3.2のヘッダーには`!`で始まるコマンドの標準出力を使える。SOPSが実行時に復号したファイルを参照するコマンドだけを設定に記載する候補とし、キーの値をNix評価時に読み込まない。キー登録・秘密ファイル変更はまだ行っていない。

## 次段階の検証条件

Composio Connectを候補として、実際のツール定義・アカウント選択・認証保存先・利用条件を確認する。Google API・OAuth・セッション管理の独自実装は行わない。書き込み機能は、単一接続時も含めて対象指定を強制できることが確認できるまで採用しない。読み取りだけの構成も、サービス側の権限やツール制限で書き込みを防げることを検証してから採用する。

## 実装状態

Home Managerは`sops.secrets.composio_api_key`が宣言された場合だけ、既定プロファイルのMCP設定を生成する。キーは実行時の秘密ファイルから読み、Composio接続は既定で無効にする。[登録手順と有効化条件](../omp-google.md)を参照する。

キーの登録・Nix設定のactivation・ログイン・Googleデータへのアクセスはまだ行っていない。全書き込み経路での対象指定の強制も未検証であり、完成条件は未達。
