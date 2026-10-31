# OMP設定

`agent/config.yml`と`agent/jev-auto-mode.json`を管理します。
認証情報、セッション、履歴、DB、キャッシュは管理対象に含めません。

Home Managerは各ファイルをこのディレクトリへリンクします。
OMPから保存した設定変更もdotfilesの差分になります。
初回適用時はホーム側の既存ファイルと衝突するため、内容が一致することを確認し、
既存ファイルをバックアップしてから通常のNix設定反映を行ってください。

Jev拡張のリンク保存修正とテストは`omp-jev-auto-mode`リポジトリで管理します。
ソースは `plugins/npins/sources.json` にリビジョンとハッシュを固定します。
`npins -d omp/plugins/npins update omp-jev-auto-mode` で個別更新できます
（リポジトリルートで `nix shell --inputs-from . nixpkgs#npins` を使用）。
`omp-ponytail-caveman` も同じロックで管理します。

Herdr連携拡張はHerdr自身が管理します。必要な場合は`herdr integration install omp`で
導入してください。
