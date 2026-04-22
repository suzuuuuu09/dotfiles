---
name: obsidian-agent-memory
description: "Use this skill aggressively whenever the user asks to remember/save/recall prior context, asks to check notes before starting work, or gives durable decisions (方針・制約・次回やること) that should be stored. Trigger even if the user does not explicitly say 'メモ' when intent implies continuity across turns/sessions. Mandatory trigger moments: (1) conversation start with likely project context, (2) immediately before starting a new task, (3) right after meaningful outcomes/decisions/errors are produced. Keywords include: '覚えておいて', '記録して', 'メモして', '前回の内容', 'ノートを見て', 'remember this', 'save this', 'what did we discuss', 'check your notes'. Read from Obsidian memories first, then write back to memories/projects or category folders."
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

## Trigger Policy（発火条件）

以下に当てはまるときは、このスキルを使う:

1. ユーザーが「保存・記録・覚えておいて」を明示したとき
2. ユーザーが「以前の内容を参照してから進めて」と求めたとき
3. 明示要求がなくても、将来再利用すべき決定事項（方針、制約、失敗原因、次回TODO）が出たとき
4. 会話開始時にプロジェクト文脈があり、過去メモ参照が有効そうなとき
5. 新しい実装/調査/デバッグタスクに着手する直前

逆に、単発の雑談や一時的な情報で再利用価値が低い場合は保存を省略してよい。

### Trigger Strength（強度）

- **Strong Trigger（即時実行）**
  - 「前回のメモを確認」「ノートを見てから」「覚えておいて」「記録して」
  - 「今後もこの方針」「次回も同じ方針」「この制約で継続」
  - 「実装に入る」「着手する」「進める」（既存プロジェクト文脈あり）
- **Weak Trigger（文脈確認して実行）**
  - 提案段階の文言（例: 「〜しようか」）で、方針確定が不明な場合
  - 単発質問で再利用価値が低い場合

Weak Triggerでも、再利用価値（次回に効く制約・方針・失敗知見）が高ければ保存する。

### 再読の境界ルール

- 同一タスクの継続でも、30分以上の中断後は再読を実行する
- 中断が30分未満でも、要件変更・方針変更・担当変更があれば再読する

「新規タスク」とみなす条件（いずれか1つで新規扱い）:

1. ユーザーの目的が変わる（実装→調査、調査→修正 など）
2. 成果物の種類が変わる（コード変更→設計提案、実装→運用手順）
3. 対象スコープが変わる（別プロジェクト、別モジュール、別機能）
4. ユーザーが明示的に切り替えを宣言する（「次は」「別件」「ここからは」）

### 暗黙SAVEの判定基準（再利用価値）

次のいずれかを含む場合は、メモ要求がなくても保存する:

1. 継続方針（「今後この方針」「次回も同じ」）
2. 制約条件（バージョン固定、禁止事項、運用ルール）
3. 再発しうる失敗知見（原因と回避策）
4. 次回TODOが明確な決定事項

## 実行フロー（先に読む）

### 1) 会話の最初に読む

会話開始時は、まず関連メモを検索・読込してから通常作業に入る:

1. 現在のリポジトリ名・技術スタック・ユーザー依頼の要点を抽出する
2. `memories/projects/{project-name}/` を最優先で確認する
3. 該当が薄い場合は `reference/`, `learning/`, `troubleshooting/`, `architecture/`, `tools-commands/` を横断検索する
4. 見つかったメモの summary と更新日を確認し、今回の作業に関係するものだけを短く要約して利用する

ユーザーが「前回のメモを確認してから」と明示した場合は、他の作業より先に即時READを行う。

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

1. **Read**: 候補メモを0-10件集める（0件でも可。0件時は「該当なし」を明示して続行）
2. **Decide**: 各メモを関連度で評価する
  - 高: 今回のタスクに直接使える手順・制約・既知の落とし穴
  - 中: 補助的に使える設計方針・参考知識
  - 低: 今回は使わない背景情報
3. **Use**: 高関連メモを優先して実行計画と実装方針に反映する
4. **Writeback**: 作業後に差分知見をメモへ追記し、次回の精度を上げる

### 5) 応答への反映ルール（必須）

メモを読んだだけで終わらせないため、作業説明には次を含める:

1. どのメモ方針を採用したか（1-3点）
2. 検討したが採用しなかったメモと理由（1行ずつ、最低1件）
3. 今回新たに得た知見をどこへ保存するか
4. 次回着手時にどの順で再読するか（project→cross-category）

※ 詳細を毎回長文で出す必要はない。短く要点だけ反映すればよい。

#### 応答テンプレート（固定）

メモ活用を伴う応答では、以下の見出しをこの順序で含める:

1. `採用したメモ`
2. `採用しなかったメモ`
3. `今回の実行計画`
4. `保存先（Writeback）`
5. `次回の再読順`

実行計画では、各ステップの末尾に対応メモを `[source: <path>]` 形式で明記する。

### 6) 競合時の意思決定ログ（必須）

過去メモと現在要求が矛盾する場合は、保存メモ本文に次のログを残す:

```md
## Decision Log
- Previous policy: <旧方針>
- New policy: <新方針>
- Why changed: <現在要求を優先した理由>
- Effective from: <適用開始タイミング>
- Related old memo: <旧メモパス>
```

### 7) 失敗時の再試行ルール

読込失敗時は以下を適用する:

1. 同一操作を最大1回だけ再試行する
2. それでも失敗したら「どのパスの読込に失敗したか」を1行で共有して継続する
3. 作業完了後、`troubleshooting/` か対象プロジェクト配下に失敗記録をWritebackする

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
created: 2025-01-15  # 必ず YYYY-MM-DD（ゼロ埋め）形式
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
