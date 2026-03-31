# メモの具体例とワークフロー

このドキュメントでは、様々なタイプのメモの具体例とワークフローを示します。

## 目次

1. [プロジェクトメモ（基本）](#プロジェクトメモ基本)
2. [プロジェクトメモ（階層構造）](#プロジェクトメモ階層構造)
3. [学習メモ](#学習メモ)
4. [リファレンスメモ（既存カテゴリ）](#リファレンスメモ既存カテゴリ)
5. [リファレンスメモ（新規カテゴリ）](#リファレンスメモ新規カテゴリ)
6. [tools-commands メモ（新規カテゴリ）](#tools-commandsメモ新規カテゴリ)
7. [ワークフロー](#ワークフロー)

## プロジェクトメモ（基本）

**場所**: `memories/projects/project-x/authentication-setup.md`

```markdown
---
summary: "Authentication flow implementation with OAuth2 and JWT tokens"
created: 2025-01-15
updated: 2025-01-20
status: in-progress
tags: [auth, oauth2, jwt, security]
related: [src/auth/oauth.ts, src/auth/jwt.ts]
---

# OAuth2 + JWT Authentication Flow

## Context
Project X requires secure authentication with external service integration.

## Implementation Details
- OAuth2 authorization code flow for user login
- JWT tokens for API authentication
- Refresh token rotation every 7 days

## Current State
- OAuth2 provider setup: DONE
- JWT token generation: DONE
- Token refresh endpoint: IN PROGRESS

## Files Modified
- `src/auth/oauth.ts` - OAuth2 handler
- `src/auth/jwt.ts` - JWT utilities
- `src/middleware/auth.ts` - Auth middleware

## Next Steps
- Implement token refresh endpoint
- Add logout endpoint
- Write integration tests
```

## プロジェクトメモ（階層構造）

**場所**: `memories/projects/my-app/frontend/react/component-patterns.md`

```markdown
---
summary: "my-app フロントエンド: React コンポーネント設計方針"
created: 2025-01-15
status: in-progress
tags: [react, components, frontend, my-app]
---

# React Component Architecture for my-app

## 設計原則
- Presentational / Container パターン
- Custom hooks による状態管理
- Props Drilling を避ける

## コンポーネント構成
```
src/components/
├── common/       # 再利用可能な UI コンポーネント
├── pages/        # ページレベルのコンポーネント
└── features/     # 機能別グループ
```

## 例
[実装例...]
```

## 学習メモ

**場所**: `memories/learning/nodejs/event-loop.md`

```markdown
---
summary: "Node.js event loop: microtasks vs macrotasks execution order"
created: 2025-01-15
status: resolved
tags: [nodejs, eventloop, javascript]
---

# Node.js Event Loop Order

## Key Insight
Microtasks (Promises, async/await) execute BEFORE macrotasks (setTimeout, setInterval).

## Order of Execution
1. Synchronous code
2. Microtasks (Promises)
3. Render (browsers only)
4. Macrotasks (setTimeout, etc)

## Example
```javascript
// Microtask before macrotask
Promise.resolve().then(() => console.log('microtask'));
setTimeout(() => console.log('macrotask'), 0);
// Output: microtask, macrotask
```
```

## リファレンスメモ（既存カテゴリ）

**場所**: `memories/reference/cors-error-fix.md`

```markdown
---
summary: "Solution: Fix CORS errors with specific headers configuration"
created: 2025-01-15
status: resolved
tags: [cors, http, debugging]
---

# CORS Error Fix

## Problem
Request failed with CORS error when calling external API.

## Root Cause
API endpoint wasn't configured with proper Access-Control-Allow-Origin headers.

## Solution
Add these headers to response:
```
Access-Control-Allow-Origin: https://your-domain.com
Access-Control-Allow-Methods: GET, POST, OPTIONS
Access-Control-Allow-Headers: Content-Type, Authorization
```

## Prevention
Always check CORS headers in API responses before assuming client-side issue.
```

## リファレンスメモ（新規カテゴリ）

**場所**: `memories/reference/nix-darwin/home-manager-setup.md`

```markdown
---
summary: "Nix darwin 環境: home-manager による完全な dotfiles 管理"
created: 2025-01-15
updated: 2025-01-20
status: resolved
tags: [nix, darwin, configuration, home-manager]
---

# home-manager Setup on macOS

## 前提
- Nix is installed
- macOS with Apple Silicon または Intel

## インストール
[インストール手順...]

## 設定ファイル構成
```
flake.nix
├── inputs: home-manager
└── outputs: homeConfigurations
```

## よくある設定
- Zsh / Fish シェル設定
- Tmux / Neovim 設定
- 開発環境（Node, Python, Rust など）

## 実装例
[実装例...]

## Tips
- Generational rollback が可能
- 複数マシンで共有可能
```

## tools-commandsメモ（新規カテゴリ）

**場所**: `memories/tools-commands/nix/flake-commands.md`

```markdown
---
summary: "Nix flake よく使うコマンド集"
created: 2025-01-15
tags: [nix, flake, cli, commands]
---

# Nix Flake Commands Cheatsheet

## 環境構築
```bash
nix flake init                    # テンプレートから初期化
nix flake show                    # フレーク内容を表示
nix develop                       # 開発環境に入る
nix develop .#<name>             # 特定の開発環境に入る
```

## ビルド・実行
```bash
nix build                         # デフォルトパッケージをビルド
nix build .#<name>               # 特定パッケージをビルド
nix run                           # デフォルトアプリを実行
nix run .#<name>                 # 特定アプリを実行
```

## 更新・ロック
```bash
nix flake update                  # flake.lock を更新
nix flake update <input>          # 特定入力を更新
```

## デバッグ
```bash
nix flake prefetch <url>          # URL をプリフェッチ
nix eval                          # Nix 式を評価
```
```

## ワークフロー

### 汎用メモを保存するとき

1. ユーザーが有用な発見や解決方法を共有、または見つける
2. **メモの種類を判定**: プロジェクト固有か、複数プロジェクトで再利用可能か
3. 適切なカテゴリ（learning, reference, troubleshooting, architecture, tools-commands）を選ぶ
4. **新しいカテゴリが必要か判定**: 技術スタック固有の知識？ → サブカテゴリを作成（例：reference/react/, tools-commands/nix/）
5. summaryと内容を書く
6. ユーザーに確認: 保存されたファイルのパスを表示

### プロジェクト固有メモを保存するとき

1. ユーザーがプロジェクト特有の情報を提供
2. `memories/projects/{project-name}/` に分類
3. **必要に応じてサブカテゴリを作成**: typescript/, database/, frontend/react/ など
4. ファイルを作成
5. ユーザーに確認: 保存されたファイルのパスを表示

### メモを検索するとき

1. ユーザーが「以前のメモを確認して」と言う、または関連メモが必要
2. Obsidian 内の検索結果を参照（キーワードやタグで検索）
3. 関連するメモを読んで提供
4. 必要に応じて、新しい情報で更新を提案

### メモを整理するとき

1. 定期的に `memories/inbox/` をチェック
2. 未整理のメモを適切なカテゴリに移動
3. 古い情報は削除または更新
4. カテゴリが複雑になった場合、さらに細かく分割（例：reference/ → reference/react/hooks/, reference/react/performance/）
5. プロジェクト終了時に `memories/projects/{project-name}` を整理（アーカイブまたは削除）
