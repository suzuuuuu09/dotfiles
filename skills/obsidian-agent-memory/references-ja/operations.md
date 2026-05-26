# メモの操作：保存・検索・管理

このドキュメントでは、メモの保存、検索、管理、トラブルシューティングの方法について説明します。

## 目次

1. [メモの保存](#メモの保存)
2. [メモの検索](#メモの検索)
3. [メモの管理](#メモの管理)
4. [トラブルシューティング](#トラブルシューティング)

## メモの保存

### 基本的な流れ

1. **メモの種類を判定**
   - プロジェクト固有？ → `memories/projects/{project-name}/`
   - 複数プロジェクトで再利用可能？ → 汎用フォルダに保存

2. **汎用メモの場合、カテゴリを選ぶ**
   - 技術的発見 → `learning/`
   - 解決方法 → `reference/`
   - 反復される問題 → `troubleshooting/`
   - 設計パターン → `architecture/`
   - コマンド・スクリプト → `tools-commands/`
   - 不明 → `inbox/` (後で分類)
   - **新しいカテゴリが必要？** 自由に作成してください

3. **ファイルを作成**

```bash
# 汎用リファレンスの例（既存カテゴリ）
mkdir -p ~/Documents/Vault/memories/reference/
cat > ~/Documents/Vault/memories/reference/cors-error-fix.md << 'EOF'
---
summary: "CORS エラーの解決方法と設定ガイド"
created: 2025-01-15
tags: [cors, http, troubleshooting]
---

# CORS エラーの解決方法

## 問題
リクエストが CORS エラーで失敗する...
EOF

# 汎用リファレンスの例（新規カテゴリ作成）
mkdir -p ~/Documents/Vault/memories/reference/nix-darwin/
cat > ~/Documents/Vault/memories/reference/nix-darwin/home-manager-setup.md << 'EOF'
---
summary: "home-manager による dotfiles 管理とシステム設定"
created: 2025-01-15
tags: [nix, darwin, configuration]
---

# home-manager Setup Guide

home-managerを使用した設定管理...
EOF

# 学習メモの例
mkdir -p ~/Documents/Vault/memories/learning/
cat > ~/Documents/Vault/memories/learning/nodejs-eventloop.md << 'EOF'
---
summary: "Node.js イベントループ: microtasks vs macrotasks"
created: 2025-01-15
status: resolved
tags: [nodejs, eventloop, javascript]
---

# Node.js イベントループ

Microtasks (Promises) は macrotasks (setTimeout) より先に実行される...
EOF

# プロジェクト固有メモの例（基本構造）
mkdir -p ~/Documents/Vault/memories/projects/my-app/
cat > ~/Documents/Vault/memories/projects/my-app/authentication-setup.md << 'EOF'
---
summary: "my-app の OAuth2 + JWT 認証実装"
created: 2025-01-15
status: in-progress
tags: [auth, my-app]
---

# Authentication Setup for my-app

このプロジェクト特有の認証実装について...
EOF

# プロジェクト固有メモの例（サブカテゴリ）
mkdir -p ~/Documents/Vault/memories/projects/my-app/frontend/react/
cat > ~/Documents/Vault/memories/projects/my-app/frontend/react/component-patterns.md << 'EOF'
---
summary: "my-app の React コンポーネント設計パターン"
created: 2025-01-15
tags: [react, components, my-app]
---

# React Component Patterns for my-app

このプロジェクトで使用するコンポーネント設計...
EOF

# tools-commands の例（新規カテゴリ）
mkdir -p ~/Documents/Vault/memories/tools-commands/nix/
cat > ~/Documents/Vault/memories/tools-commands/nix/flake-commands.md << 'EOF'
---
summary: "Nix flake よく使うコマンド集"
created: 2025-01-15
tags: [nix, flake, cli]
---

# Nix Flake Commands Cheatsheet

フレーク開発に必要なコマンド...
EOF
```

### ファイル命名規則

- kebab-caseを使用: `my-feature-name.md`
- わかりやすく、内容を反映させる
- 日付は必要ない（frontmatterに記録）

## メモの検索

### Obsidian内での検索

Obsidianの検索機能を使用:

1. **Quick Open** (`Cmd/Ctrl+P`): ファイル名で検索
2. **Global Search** (`Cmd/Ctrl+Shift+F`): 全文検索
3. **Link suggestions**: `[[` で関連ファイルを発見

### コマンドラインでの検索

ユーザーが手動で検索する場合用（参考）:

```bash
# summaryフィールドを確認
grep -r "^summary:" ~/Documents/Vault/memories/ | head -20

# キーワードで検索
grep -r "keyword" ~/Documents/Vault/memories/ -i

# 特定のタグを検索
grep -r "tags:.*keyword" ~/Documents/Vault/memories/ -i

# 特定のカテゴリ内で検索
grep -r "keyword" ~/Documents/Vault/memories/reference/nix-darwin/ -i
```

## メモの管理

### 更新

情報が変更されたら、内容を更新し、frontmatterに`updated`フィールドを追加:

```yaml
---
summary: "更新されたサマリー"
created: 2025-01-15
updated: 2025-01-20
status: resolved
---
```

### 削除

不要になったメモは削除。空のフォルダもクリーンアップ。

### 統合

同じトピックの関連メモは、必要に応じて統合:

```bash
# ファイルを統合したら、古いファイルは削除
rm ~/Documents/Vault/memories/category/old-file.md
```

### 再整理

知識ベースが成長したら、メモを更に良いカテゴリに移動:

```bash
# 例1: inboxから適切なカテゴリへ
mv ~/Documents/Vault/memories/inbox/note.md \
   ~/Documents/Vault/memories/reference/note.md

# 例2: 新しいサブカテゴリを作成して移動
mkdir -p ~/Documents/Vault/memories/reference/react-hooks/
mv ~/Documents/Vault/memories/reference/hooks-*.md \
   ~/Documents/Vault/memories/reference/react-hooks/
```

## トラブルシューティング

### Vaultにアクセスできない

```bash
# パスを確認
ls -la ~/Documents/Vault/

# メモリフォルダを作成
mkdir -p ~/Documents/Vault/memories/{projects,reference,learning,troubleshooting,architecture,tools-commands,inbox}
```

### ファイル名の競合

既存ファイルを上書きしないよう、ユーザーに確認してから保存。

### メモが見つからない

Obsidian内の検索を使用、またはタグで分類されているかを確認。特定のサブカテゴリにあるか確認してください。

### フォルダ構造が複雑になってきた

定期的に知識ベースを見直し、さらに細かく分割するか、統合するかを検討してください。必要に応じて新しいサブカテゴリを作成することで、整理を保つことができます。
