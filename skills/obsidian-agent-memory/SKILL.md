---
name: obsidian-agent-memory
description: "Use when: メモを残したい、会話内容を記録したい、以前の内容を思い出したい、会話開始時に関連メモを先読みしたい、作業着手前に過去メモを参照したいとき。Triggers: 'メモリに保存して', '覚えておいて', 'この内容を記録して', 'ノートして', '以前のメモを読んで', '会話の最初にメモを確認して', 'remember this', 'save this', 'note this', 'what did we discuss about', 'check your notes', 'clean up memories'。Obsidian vaultのmemories配下に保存・整理・検索し、プロジェクト固有メモはprojects配下で管理する。"
---

# Obsidian Agent Memory

Obsidian vaultにメモを永続的に保存し、複数の会話にわたって知識を保持できるスキル。

**Vault Location:** `~/Documents/Vault/`
**Memory Folder:** `memories/`

## 概要

このスキルを使用して、メモの保存・整理・検索を行います。

このスキルが有効なときは、保存だけでなく「最初に読む」ことを優先します。

- **プロジェクト関連**: `memories/projects/` 配下に保存
- **その他**: `memories/` 直下に自動分類フォルダを作成

## 実行フロー（先に読む）

### 1) 会話の最初に読む

会話開始時は、まず関連メモを検索・読込してから通常作業に入る:

1. 現在のリポジトリ名・技術スタック・ユーザー依頼の要点を抽出する
2. `memories/projects/{project-name}/` を最優先で確認する
3. 該当が薄い場合は `reference/`, `learning/`, `troubleshooting/`, `architecture/`, `tools-commands/` を横断検索する
4. 見つかったメモの summary と更新日を確認し、今回の作業に関係するものだけを短く要約して利用する

### 2) 何か作業を始める前に再確認する

新しいタスクに着手する直前は、直近で関係しそうなメモを再読する:

1. タスク種別を判定する（実装・調査・デバッグ・設計・運用）
2. 対応するカテゴリを優先読込する
  - 実装/調査: `reference/`, `learning/`
  - デバッグ: `troubleshooting/`
  - 設計: `architecture/`
  - コマンド操作: `tools-commands/`
3. 過去メモと今回の要求が矛盾する場合は、古いメモより現在の要求を優先し、必要なら更新メモを残す

### 3) 読めなかった場合のフォールバック

アクセス不可・該当なしの場合はその旨を短く共有し、メモなしで作業を進める。作業後に新規メモを作って次回の先読み精度を上げる。

### 4) 活用ループ（Read -> Decide -> Use -> Writeback）

読んだメモを実際の成果に結びつけるため、以下を必ず回す:

1. **Read**: 候補メモを3-10件集める
2. **Decide**: 各メモを関連度で評価する
  - 高: 今回のタスクに直接使える手順・制約・既知の落とし穴
  - 中: 補助的に使える設計方針・参考知識
  - 低: 今回は使わない背景情報
3. **Use**: 高関連メモを優先して実行計画と実装方針に反映する
4. **Writeback**: 作業後に差分知見をメモへ追記し、次回の精度を上げる

### 5) 応答への反映ルール

メモを読んだだけで終わらせないため、作業説明には次を含める:

1. どのメモ方針を採用したか（1-3点）
2. 採用しなかったメモの理由（必要な場合のみ）
3. 今回新たに得た知見をどこへ保存するか

※ 詳細を毎回長文で出す必要はない。短く要点だけ反映すればよい。

### Vault構造の概要

```
~/Documents/Vault/
├── memories/
│   ├── projects/              # プロジェクト固有のメモ（各プロジェクトに独立）
│   ├── reference/             # 汎用リファレンス・解決策（全プロジェクトで再利用）
│   ├── learning/              # 学習・発見・パターン（複数プロジェクトに応用可能）
│   ├── troubleshooting/       # トラブルシューティング（共通の問題解決）
│   ├── architecture/          # アーキテクチャ・設計パターン（再利用可能）
│   ├── tools-commands/        # ツール・コマンド・スニペット集
│   └── inbox/                 # 未整理のメモ（後で汎用フォルダに分類）
└── (その他のvault内容)
```

詳細なVault構造とフォルダの使い分けについては、`references/vault-structure.md` を参照してください。

## 積極的な使用

### 汎用メモを保存する場合（プロジェクトを超えて再利用）

以下の場合、各カテゴリに自動的にメモを保存:

- **Learning**: 技術的な発見、パターン、ベストプラクティス
  - イベントループの仕組み、パフォーマンス最適化パターンなど
- **Reference**: 解決策、手順、ハウツー
  - エラー解決方法、API設定方法、設定ガイドなど
  - **新規カテゴリも自由に作成**: react/, nix-darwin/, typescript/ など
- **Troubleshooting**: 繰り返し出現する問題と解決方法
  - メモリリーク診断、タイムアウト対応など
- **Architecture**: 再利用可能な設計パターン
  - マイクロサービスパターン、キャッシング戦略など
- **Tools-Commands**: よく使うコマンド、スクリプト、設定
  - Docker コマンド、Git ワークフロー、CLI設定など
  - **新規ツールカテゴリも自由に作成**: docker/, nix/, jq/ など

### プロジェクト固有のメモを保存する場合

- プロジェクト特有の仕様、実装ノート、設定
- 特定プロジェクトでのみ使用される情報
- → `memories/projects/{project-name}/` に保存
- **必要に応じてサブカテゴリを作成**: typescript/, database/, frontend/react/ など

### メモを検索・参照する場合

関連する汎用メモを確認:

- 新しい技術を学習するとき → `learning/` を確認
- エラーが出たとき → `troubleshooting/` を確認
- 実装方法を知りたいとき → `reference/` を確認
- アーキテクチャを設計するとき → `architecture/` を確認
- コマンドを忘れたとき → `tools-commands/` を確認
- 特定の技術スタック（React, Nix, TypeScriptなど）について → 対応するサブカテゴリを確認

## ファイル形式

すべてのメモには、Markdownフロントマター（YAML）が必須：

```yaml
---
summary: "このメモが何を含むかの簡潔な説明（1-2行）"
created: 2025-01-15  # YYYY-MM-DD format
---
```

オプションフィールド:

```yaml
---
summary: "Worker thread memory leak during large file processing - cause and solution"
created: 2025-01-15
updated: 2025-01-20
status: in-progress  # in-progress | resolved | blocked | abandoned
tags: [performance, worker, memory-leak]
related: [src/core/file/fileProcessor.ts]
---
```

## メモの操作

### 保存
メモの保存方法、ファイル命名規則、カテゴリ選択について、詳しくは `references/operations.md` の「メモの保存」セクションを参照してください。

### 検索
Obsidian内での検索方法やコマンドラインでの検索方法については、`references/operations.md` の「メモの検索」セクションを参照してください。

### 管理
メモの更新、削除、統合、再整理の方法については、`references/operations.md` の「メモの管理」セクションを参照してください。

## 具体例

様々なタイプのメモの具体例については、`references/examples.md` を参照してください:
- プロジェクトメモ（基本・階層構造）
- 学習メモ
- リファレンスメモ（既存・新規カテゴリ）
- tools-commands メモ
- ワークフロー例

## ガイドライン

1. **自己完結的に書く**: 以前の知識がなくても理解できるように、完全な文脈を含める
2. **summaryを決定的に**: summaryを読むだけで、詳細を読む必要があるかわかるように
3. **最新に保つ**: 古い情報は更新または削除
4. **実用的に**: 実際に有用なものだけを保存。すべてを保存する必要はない
5. **積極的に拡張**: 新しいカテゴリが必要と感じたら、遠慮なく作成
6. **意思決定に使う**: メモは記録用ではなく、次のタスクの判断材料として使う
7. **作業後に還元する**: 新しい失敗例・成功例・手順差分は必ず書き戻す

## メモの内容

詳細なメモを書くときは、以下を検討:

- **Context**: 目標、背景、制約
- **State**: 何が終わったか、進行中か、ブロックされているか
- **Details**: キーとなるファイル、コマンド、コードスニペット
- **Next steps**: 次にすることは？未解決の質問は？

すべてのメモが全セクションを必要とするわけではない。関連するものだけを使用してください。

## トラブルシューティング

基本的なトラブルシューティングについては、`references/operations.md` の「トラブルシューティング」セクションを参照してください。

## 参考資料

- **Vault構造の詳細**: `references/vault-structure.md` - フォルダ構造、柔軟性、各フォルダの役割
- **具体例集**: `references/examples.md` - 様々なタイプのメモの実例
- **操作ガイド**: `references/operations.md` - 保存、検索、管理、トラブルシューティング
