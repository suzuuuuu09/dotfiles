# Vault構造の詳細

このドキュメントでは、Obsidian Vaultのフォルダ構造、柔軟性、および各フォルダの役割について詳しく説明します。

## 完全なVault構造

```
~/Documents/Vault/
├── memories/
│   ├── projects/              # プロジェクト固有のメモ（各プロジェクトに独立）
│   │   ├── project-a/
│   │   │   ├── typescript/
│   │   │   ├── database/
│   │   │   ├── deployment/
│   │   │   └── ...
│   │   ├── project-b/
│   │   └── project-c/
│   │
│   ├── reference/             # 汎用リファレンス・解決策（全プロジェクトで再利用）
│   │   ├── nix-darwin/
│   │   ├── react/
│   │   ├── typescript/
│   │   ├── database/
│   │   └── ...
│   ├── learning/              # 学習・発見・パターン（複数プロジェクトに応用可能）
│   │   ├── nodejs/
│   │   ├── performance/
│   │   └── ...
│   ├── troubleshooting/       # トラブルシューティング（共通の問題解決）
│   ├── architecture/          # アーキテクチャ・設計パターン（再利用可能）
│   ├── tools-commands/        # ツール・コマンド・スニペット集
│   │   ├── docker/
│   │   ├── git/
│   │   ├── nix/
│   │   └── ...
│   └── inbox/                 # 未整理のメモ（後で汎用フォルダに分類）
└── (その他のvault内容)
```

## 📌 重要：フォルダ構造の柔軟性

このVaultの構造は**固定的ではありません**。必要に応じて、以下のような細分化や拡張を自由に行ってください。

### 基本原則

- ✅ **サブカテゴリフォルダを積極的に作成してください**
- ✅ **深さに制限はありません** → `reference/frontend/react/hooks/` のような階層化も可
- ✅ **不要なフォルダは削除・整理して OK**
- ✅ **成長に合わせて構造を変更することを推奨します**

### プロジェクト内での階層化

```
projects/my-app/
├── typescript/
│   ├── type-definitions.md
│   └── generic-patterns.md
├── database/
│   ├── schema-design.md
│   └── migrations.md
├── deployment/
│   ├── docker-setup.md
│   └── ci-cd-pipeline.md
├── frontend/
│   └── react/
│       ├── component-architecture.md
│       ├── hooks-optimization.md
│       └── styling-strategy.md
└── backend/
    ├── api/
    │   ├── authentication-flow.md
    │   └── error-handling.md
    └── services/
        └── database-layer.md
```

**ポイント**: 階層の深さは自由。プロジェクトの複雑さに応じて増やしたり減らしたりできます。

### 汎用カテゴリの拡張

```
reference/
├── nix-darwin/
│   ├── home-manager-config.md
│   ├── flake-best-practices.md
│   └── module-composition.md
├── react/
│   ├── hooks/
│   │   ├── custom-hooks-patterns.md
│   │   └── hooks-performance.md
│   ├── performance-optimization.md
│   └── testing-strategies.md
├── typescript/
│   ├── advanced-types.md
│   ├── generics/
│   │   ├── generic-constraints.md
│   │   └── conditional-types.md
│   └── type-inference.md
├── api-design/
│   ├── rest-conventions.md
│   └── graphql-patterns.md
└── database/
    ├── migrations.md
    └── indexing-strategies.md
```

**ポイント**: 関連テーマをサブフォルダにグループ化することで、整理がしやすくなります。

### learning フォルダの拡張例

```
learning/
├── nodejs/
│   ├── event-loop.md
│   ├── streams.md
│   └── worker-threads.md
├── performance/
│   ├── profiling-techniques.md
│   └── optimization-patterns.md
├── security/
│   ├── authentication-methods.md
│   └── data-encryption.md
└── architecture/
    ├── microservices.md
    └── event-driven-design.md
```

### tools-commands の細分化

```
tools-commands/
├── docker/
│   ├── docker-compose.md
│   ├── image-optimization.md
│   └── networking.md
├── git/
│   ├── branching-strategy.md
│   ├── cherry-pick-guide.md
│   └── advanced-workflows.md
├── nix/
│   ├── flake-commands.md
│   ├── nix-shell-setup.md
│   └── package-management.md
├── cli-tools/
│   ├── jq-recipes.md
│   ├── find-commands.md
│   └── sed-awk-patterns.md
└── terminal/
    ├── tmux-config.md
    └── shell-keybindings.md
```

**ポイント**: ツールごとにサブフォルダを作成することで、関連コマンドを一箇所に集約できます。

## フォルダの説明

### `projects/` - プロジェクト固有

- **用途**: 特定のプロジェクトにのみ関連する情報
- **例**: プロジェクトAの仕様書、実装ノート、プロジェクト固有の設定
- **基本構造**: `projects/{project-name}/{topic}.md`
- **拡張構造**: 必要に応じてサブカテゴリを自由に作成
  - `projects/my-app/typescript/type-definitions.md`
  - `projects/my-app/database/schema-design.md`
  - `projects/my-app/frontend/react/component-patterns.md`
  - `projects/my-app/backend/api/authentication-flow.md`
- **寿命**: プロジェクト終了後、アーカイブまたは削除可能

### `reference/` - 汎用リファレンス

- **用途**: 複数プロジェクトで参照可能な解決策・方法論
- **基本例**: 
  - CORS エラーの解決方法
  - API authentication パターン
  - Database migration 手順
- **拡張例**（自由に作成可能）:
  - `reference/nix-darwin/` - NixOS/darwin設定ガイド
  - `reference/react/` - React パターンと最適化
  - `reference/typescript/` - TypeScript 高度な型テクニック
- **特徴**: プロジェクトに依存しない一般的な知識
- **拡張**: 技術スタックに応じてサブカテゴリを自由に追加

### `learning/` - 学習・発見・パターン

- **用途**: 技術的発見、パターン、ベストプラクティス
- **例**:
  - Node.js イベントループの仕組み
  - React レンダリング最適化パターン
  - TypeScript 型推論のコツ
- **拡張例**:
  - `learning/nodejs/` - Node.jsの深掘り学習
  - `learning/performance/` - パフォーマンス最適化パターン
  - `learning/security/` - セキュリティベストプラクティス
- **特徴**: 複数プロジェクトに応用可能な知識

### `troubleshooting/` - 共通問題解決

- **用途**: 繰り返し出現する問題とその解決方法
- **例**:
  - メモリリーク診断方法
  - ネットワークタイムアウト対応
  - ビルドエラー解決ガイド

### `architecture/` - 設計パターン・図面

- **用途**: 再利用可能なアーキテクチャ設計
- **例**:
  - マイクロサービスパターン
  - キャッシング戦略
  - スケーリング方法論

### `tools-commands/` - ツール・コマンド集

- **用途**: よく使うコマンド、スクリプト、ツール設定
- **基本例**:
  - Docker コマンドチートシート
  - Git ワークフロー
  - CLI ツール設定
  - useful one-liners
- **拡張例**（自由に作成可能）:
  - `tools-commands/docker/` - Dockerコマンド集
  - `tools-commands/nix/` - Nixコマンド集とflakeの例
  - `tools-commands/git/` - Gitワークフロー詳解
  - `tools-commands/jq/` - jqレシピ集

### `inbox/` - 未整理

- **用途**: 一時的に保存されるメモ
- **プロセス**: 定期的に適切なカテゴリに移動
