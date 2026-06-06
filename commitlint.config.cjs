module.exports = {
	parserPreset: {
		parserOpts: {
			// 先頭のgitmojiを許可しつつ、Conventional Commitsとして読む
			// 例: ✨ feat(nvim): obsidianのworkspace設定を追加
			headerPattern:
				/^(?:\p{Emoji_Presentation}|\p{Emoji}\uFE0F)?\s?(\w*)(?:\((.*)\))?!?: (.*)$/u,
			headerCorrespondence: ["type", "scope", "subject"],
		},
	},

	rules: {
		// @see: https://commitlint.js.org/#/reference-rules

		"type-enum": [
			2,
			"always",
			[
				"feat",
				"fix",
				"update",
				"docs",
				"style",
				"refactor",
				"perf",
				"test",
				"build",
				"ci",
				"chore",
				"revert",
				"wip",
			],
		],

		"type-empty": [2, "never"],
		"subject-empty": [2, "never"],
		"header-max-length": [2, "always", 100],
	},

	prompt: {
		alias: {
			fd: "docs: fix typos",
		},

		messages: {
			type: "変更の種類を選択してください:",
			scope: "変更のスコープを入力してください（任意）:",
			customScope: "変更のスコープを入力してください:",
			subject: "変更内容を短く命令形で記述してください:\n",
			body: "変更内容をより詳しく記述してください（任意）。改行する場合は「|」を使用してください:\n",
			breaking:
				"破壊的変更がある場合は記述してください（任意）。改行する場合は「|」を使用してください:\n",
			footerPrefixesSelect:
				"この変更に関連するISSUEの種類を選択してください（任意）:",
			customFooterPrefix: "ISSUEのプレフィックスを入力してください:",
			footer: "関連するISSUEを記述してください。例: #4, #15:\n",
			generatingByAI: "AIがコミットメッセージを生成中...",
			generatedSelectByAI: "AIが生成した候補から選択してください:",
			confirmCommit: "上記の内容でコミットを実行しますか？",
		},

		types: [
			{
				value: "feat",
				name: "✨  feat: 新機能の追加",
				emoji: "✨",
				title: "Features",
				description: "Add new features to the codebase.",
			},
			{
				value: "fix",
				name: "🐛  fix: バグ修正",
				emoji: "🐛",
				title: "Bug Fixes",
				description: "Fix bugs in the codebase.",
			},
			{
				value: "update",
				name: "🩹  update: 既存機能や設定の小さな更新",
				emoji: "🩹",
				title: "Updates",
				description:
					"Update existing features or settings without adding new features.",
			},
			{
				value: "docs",
				name: "📝  docs: ドキュメントの追加/更新",
				emoji: "📝",
				title: "Documentation",
				description: "Add or update documentation.",
			},
			{
				value: "style",
				name: "🎨  style: コードの構造/フォーマットを改善",
				emoji: "🎨",
				title: "Code Style Improvements",
				description:
					"Improve the structure or format of the code without changing its behavior.",
			},
			{
				value: "refactor",
				name: "♻️  refactor: コードのリファクタリング",
				emoji: "♻️",
				title: "Refactoring",
				description: "Refactor code without changing its behavior.",
			},
			{
				value: "perf",
				name: "⚡️  perf: パフォーマンスの改善",
				emoji: "⚡️",
				title: "Performance Improvements",
				description: "Improve the performance of the codebase.",
			},
			{
				value: "test",
				name: "✅  test: テストの追加/修正",
				emoji: "✅",
				title: "Tests",
				description: "Add or update tests.",
			},
			{
				value: "build",
				name: "📦  build: 依存関係・ビルド設定の変更",
				emoji: "📦",
				title: "Build",
				description: "Add or update packages or dependencies.",
			},
			{
				value: "ci",
				name: "🚀  ci: CI/CDの変更",
				emoji: "🚀",
				title: "Continuous Integration",
				description: "Add or update CI/CD configuration.",
			},
			{
				value: "chore",
				name: "🔧  chore: 設定ファイルや雑務の変更",
				emoji: "🔧",
				title: "Chores",
				description: "Add or update miscellaneous tasks or configuration.",
			},
			{
				value: "revert",
				name: "⏪  revert: 以前のコミットを取り消し",
				emoji: "⏪",
				title: "Reverts",
				description: "Revert a previous commit.",
			},
			{
				value: "wip",
				name: "🚧  wip: 作業中",
				emoji: "🚧",
				title: "Work in Progress",
				description: "Work in progress, not ready for review or merging.",
			},
			{
				value: "chore",
				name: "🎉  chore: プロジェクトの開始",
				emoji: "🎉",
				title: "Initial Commit",
				description: "Initial commit to start the project.",
			},
		],

		useEmoji: true,
		emojiAlign: "center",

		useAI: true,
		aiNumber: 5,

		aiQuestionCB: ({ type, diff, maxSubjectLength }) => {
			return `
あなたはGitのコミットメッセージを作成するアシスタントです。
以下のdiffを読み取り、変更内容に合うコミットメッセージ候補を1つだけ作成してください。

# constraints
- 日本語で出力してください。
- 出力は1行だけにしてください。
- バッククォート（\`）やコードブロック（\`\`\`）は絶対に使用しないでください。
- 説明文や補足は出力しないでください。
- 句点「。」は付けないでください。
- Conventional Commits 1.0.0 に準拠する前提で作成してください。
- 変更点が複数ある場合は、一番大きい変更もしくは最も重要な変更を表現してください。
- diffから読み取れる内容だけを書いてください。
- subjectは${maxSubjectLength}文字以内を目安にしてください。
- scopeは変更対象のツール・アプリ・設定名を短い英単語で書いてください。
- scopeはファイルの場所ではなく、設定対象を優先してください。
- 複数にまたがる場合は中心となるものを1つだけ選んでください。
- 判断できない場合だけ empty と書いてください。
- descriptionは、変更内容を1文で少し詳しく説明してください。
- descriptionには「何が変わったか」または「なぜ変えたか」が分かる内容を書いてください。

# scope examples
- .github/renovate.json -> renovate
- .github/workflows/*.yml -> ci
- commitlint.config.cjs -> commitlint
- cz.config.cjs -> czg
- flake.nix -> nix
- home.nix -> nix
- lazy.lua -> nvim
- yazi.toml -> yazi
- package.json -> package

# format
<subject> (<scope>) | <description>

# good examples
obsidianのworkspace設定を追加 (nvim) | Obsidianプラグインで使用するworkspaceを明示的に設定
renovateの設定を追加 (renovate) | 依存関係更新を自動化するための設定を追加
GitHub Actionsのworkflowを修正 (ci) | CIで実行する処理が正しく動作するようにworkflowを調整
コミットメッセージの形式を修正 (commitlint) | gitmoji付きのConventional Commits形式を検証できるように調整
czgのプロンプト設定を更新 (czg) | コミット作成時の質問文と出力形式を使いやすく調整
home-managerの設定を整理 (nix) | 管理対象の設定ファイルを分かりやすく分類
パッケージ一覧を更新 (nix) | 利用する開発ツールの依存関係を現在の構成に合わせて更新
READMEの説明を追加 (docs) | セットアップ手順が分かりやすくなるように説明を追加

# bad examples
renovateの設定を追加 (github)
commitlintの設定を修正 (git)
nvimの設定を修正 (lua)
feat(nvim): obsidianのworkspace設定を追加
✨ feat(nvim): obsidianのworkspace設定を追加
以下のコミットメッセージが適切です
obsidianのworkspace設定を追加 (nvim)
obsidianのworkspace設定を追加 (nvim) | Obsidianプラグインで使用するworkspaceを明示的に設定。

# selected type
${type}

# diff
${diff}
`;
		},

		themeColorCode: "",

		scopes: [],
		allowCustomScopes: true,
		allowEmptyScopes: true,
		customScopesAlign: "bottom",
		customScopesAlias: "custom",
		emptyScopesAlias: "empty",

		// 最初の文字の大文字・小文字を変更しない
		upperCaseSubject: null,

		markBreakingChangeMode: false,
		allowBreakingChanges: ["feat", "fix"],

		breaklineNumber: 100,
		breaklineChar: "|",

		skipQuestions: [],

		issuePrefixes: [
			{
				value: "closed",
				name: "closed:   ISSUES has been processed",
			},
		],

		customIssuePrefixAlign: "top",
		emptyIssuePrefixAlias: "skip",
		customIssuePrefixAlias: "custom",
		allowCustomIssuePrefix: true,
		allowEmptyIssuePrefix: true,

		confirmColorize: true,

		scopeOverrides: undefined,

		defaultBody: "",
		defaultIssues: "",
		defaultScope: "",
		defaultSubject: "",

		formatMessageCB: ({ type, scope, subject, emoji, body }) => {
			const gitmoji = emoji ? `${emoji} ` : "";

			const [subjectPart, ...descriptionParts] = subject
				.split("|")
				.map((part) => part.trim())
				.filter(Boolean);

			const match = subjectPart.match(/^(.*)\s+\(([^()]+)\)$/);

			const parsedSubject = match ? match[1].trim() : subjectPart.trim();
			const parsedScope = match ? match[2].trim() : scope;

			const normalizedScope =
				parsedScope && parsedScope !== "empty" ? parsedScope : "";

			const commitType = normalizedScope ? `${type}(${normalizedScope})` : type;

			const header = `${gitmoji}${commitType}: ${parsedSubject}`;

			const descriptionFromAI = descriptionParts.join("\n").trim();
			const descriptionFromInput = body
				? body.replaceAll("|", "\n").trim()
				: "";
			const description = descriptionFromAI || descriptionFromInput;

			return description ? `${header}\n\n${description}` : header;
		},
	},
};
