# ローカル Agent Skills

このディレクトリには、このリポジトリで管理する自作の Agent Skills を置いています。
各スキルの詳細な動作規則は、それぞれの `SKILL.md` を参照してください。

## スキル一覧

| Skill | Description |
| --- | --- |
| [`astro-remark-rehype`](astro-remark-rehype) | Astro の remark / rehype プラグインの実装・テスト・検証を支援する。 |
| [`browser-problem-solver`](browser-problem-solver) | ブラウザ上の問題解決と、解答作成・入力作業を支援する。 |
| [`design-safe-ai-decisions`](design-safe-ai-decisions) | AI が関与する意思決定システムの評価・運用設計を支援する。 |
| [`obsidian-agent-memory`](obsidian-agent-memory) | Obsidian を使ったエージェント記憶の読み出し・整理・書き戻しを管理する。 |
| [`request-framework`](request-framework) | 依頼を目的・制約・出力・承認境界などに整理する。 |
| [`run-missing-cli`](run-missing-cli) | 不足している CLI を永続インストールせず一時的に実行する経路を案内する。 |

## ディレクトリ構成

```text
skills/
├── README.md
└── <skill-name>/
    ├── SKILL.md              # 必須: スキル本体と発動条件
    ├── agents/openai.yaml    # 任意: エージェント向けメタデータ
    └── references/           # 任意: 詳細な手順や評価資料
```

`SKILL.md` の frontmatter にある `name` はスキルの ID として使われます。
ディレクトリ名と `name` は一致させてください。

## インストールと反映

ローカルスキルは Home Manager の `personal` ソースとして登録され、
`~/.agents/skills` に配置されます。
登録内容は [.config/nix/home/common/agent-skills.nix](../.config/nix/home/common/agent-skills.nix) で管理しています。

変更を環境へ反映するには、対象環境の通常の Nix 更新を実行します。

```bash
# macOS
sudo darwin-rebuild switch --flake .#suzuMac

# NixOS-WSL
sudo nixos-rebuild switch --flake .#suzuWsl
```

反映後、`~/.agents/skills/<skill-name>` にスキルが配置されていることを確認できます。
外部ソースから取得するスキルや明示的に選択するスキルは、各ソースの定義と選択を管理する
`agent-skills.nix` 側で設定します。

## 新しいスキルを追加するとき

1. `skills/<skill-name>/SKILL.md` を作成する。
2. frontmatter に `name` と、発動条件を含む簡潔な `description` を記載する。
3. 長い手順や評価方法は `references/` に分離し、`SKILL.md` からリンクする。
4. 必要な場合だけ `agents/openai.yaml` などの補助ファイルを追加する。
5. `nix flake check` を実行し、対象環境の再ビルドで配置を確認する。

スキルの説明には「いつ使うか」と「何をしないか」を含め、他のスキルと発動条件が重ならないようにします。
