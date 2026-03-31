---
name: obsidian-agent-memory
description: "Obsidian vault内にメモを保存・整理・検索する。 Triggers: 'remember this', 'save this', 'note this', 'what did we discuss about...', 'check your notes', 'clean up memories'。 有用な発見やプロジェクト情報を見つけたときは積極的に保存する。memories/フォルダに自動保存し、projects/配下でプロジェクト固有のメモを管理。必要に応じてカテゴリは自由に拡張可能。"
---

# Obsidian Agent Memory

Obsidian vaultにメモを永続的に保存し、複数の会話にわたって知識を保持できるスキル。

**Vault Location:** `~/Documents/Vault/`
**Memory Folder:** `memories/`

## 概要

このスキルを使用して、メモの保存・整理・検索を行います。

- **プロジェクト関連**: `memories/projects/` 配下に保存
- **その他**: `memories/` 直下に自動分類フォルダを作成

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
