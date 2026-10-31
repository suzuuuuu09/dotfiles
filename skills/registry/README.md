# 外部Skillソースの管理

[agent-skills-nixの公式Source Registry](https://github.com/Kyure-A/agent-skills-nix/blob/master/docs/source-registry.md)
を使います。`sources/*.nix` に取得元と探索条件、`sources.lock.json` に
リビジョンとハッシュを保存します。選択するSkillと変換は従来どおり
`.config/nix/home/common/agent-skills.nix` で管理します。
自作Skillの置き場所やインストール先は変わりません。

すべてのコマンドはリポジトリルートで実行します。全件更新は次のとおりです。

```sh
nix run .#skills-sources-lock
nix shell --inputs-from . nixpkgs#npins -c npins -d omp/plugins/npins update
```

マニフェストの `pin.branch` は更新時に追従するブランチです。
`pin.at` を持つソースはそのコミットに固定し、更新時にも追従しません。
固定コミットを変更する場合は `pin.at` を編集してロックを再生成します。
ビルドやHome Manager適用時にはロック済みソースだけを取得します。

公式アプリは全件更新用です。Skillソースを1件だけ更新するときは、対象の
マニフェストだけを渡し、生成したロックを既存のロックへ統合します。
この方法なら `pin.at` による固定も維持されます。次は `ponytail` の例です。

```sh
work_dir=$(mktemp -d)
mkdir "$work_dir/sources"
cp skills/registry/sources/ponytail.nix "$work_dir/sources/"
nix run .#skills-sources-lock -- \
  --manifest-dir "$work_dir/sources" --lock-file "$work_dir/updated.json"
jq --slurpfile update "$work_dir/updated.json" \
  '.manifests += $update[0].manifests | .npins.pins += $update[0].npins.pins' \
  skills/registry/sources.lock.json > "$work_dir/merged.json"
# 上のコマンドがすべて成功し、差分を確認してから置き換える。
cp "$work_dir/merged.json" skills/registry/sources.lock.json
```

OMP Pluginの個別更新はnpinsの公式CLIを使います。

```sh
nix shell --inputs-from . nixpkgs#npins -c \
  npins -d omp/plugins/npins update omp-jev-auto-mode
```

日次・手動のGitHub Actionsも同じ全件更新コマンドを使い、変更がある場合は
更新PRを作成します。対象コミットのmacOS／LinuxのNix CIが成功してから
自動マージします。ロックのJSONだけが変わるPRでもNix CIが起動します。
