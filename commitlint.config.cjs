module.exports = {
	rules: {
		// @see: https://commitlint.js.org/#/reference-rules
	},
	prompt: {
		alias: { fd: "docs: fix typos" },
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
				value: "✨",
				name: "✨  新機能の追加",
				emoji: "✨",
				title: "Features",
				description: "Add new features to the codebase.",
			},
			{
				value: "⚡️",
				name: "⚡️  パフォーマンスの改善",
				emoji: "⚡️",
				title: "Performance Improvements",
				description: "Improve the performance of the codebase.",
			},
			{
				value: "🐛",
				name: "🐛  バグ修正",
				emoji: "🐛",
				title: "Bug Fixes",
				description: "Fix bugs in the codebase.",
			},
			{
				value: "🩹",
				name: "🩹  重要ではない軽微な問題の修正",
				emoji: "🩹",
				title: "Minor Fixes",
				description: "Fix minor issues that are not critical.",
			},
			{
				value: "♻️",
				name: "♻️   コードのリファクタリング",
				emoji: "♻️",
				title: "Refactoring",
				description: "Refactor code without changing its behavior.",
			},
			{
				value: "🔥",
				name: "🔥  コード/ファイルの削除",
				emoji: "🔥",
				title: "Code/Files Removal",
				description: "Remove code or files from the codebase.",
			},
			{
				value: "🎉",
				name: "🎉  プロジェクトの開始",
				emoji: "🎉",
				title: "Initial Commit",
				description: "Initial commit to start the project.",
			},
			{
				value: "🚨",
				name: "🚨  コンパイラ/リンターのエラー修正",
				emoji: "🚨 ",
				title: "Compiler/Linter Fixes",
				description: "Fix compiler or linter errors in the codebase.",
			},
			{
				value: "🎨",
				name: "🎨  コードの構造/フォーマットを改善",
				emoji: "🎨",
				title: "Code Style Improvements",
				description:
					"Improve the structure or format of the code without changing its behavior.",
			},
			{
				value: "🔧",
				name: "🔧  設定ファイルの追加/更新",
				emoji: "🔧 ",
				title: "Configuration",
				description: "Add or update configuration files.",
			},
			{
				value: "🚧",
				name: "🚧  作業中",
				emoji: "🚧",
				title: "Work in Progress",
				description: "Work in progress, not ready for review or merging.",
			},
			{
				value: "📝",
				name: "📝  ドキュメントの追加/更新",
				emoji: "📝",
				title: "Documentation",
				description: "Add or update documentation.",
			},
			{
				value: "📦",
				name: "📦  パッケージの追加/更新",
				emoji: "📦",
			},
		],
		useEmoji: true,
		emojiAlign: "center",
		useAI: false,
		aiNumber: 3,
		aiQuestionCB: ({ type, diff, maxSubjectLength }) => {
			return `
			# constraints
			- バッククォート（\`）やコードブロック（\`\`\`）は絶対に使用しないでください。
			- 日本語で出力してください。
			- 形式は conventional commits 1.0.0 に準拠してください。
			- 簡潔かつ、後で履歴を追いやすいように具体的に表現を心がけてください。
			- 変更点が複数ある場合は、一番大きい変更もしくは最も重要な変更を表現してください。2個以上は出力しないでください。
			- scopeは、変更の影響範囲を表す短い単語やフレーズで、括弧で囲んでください。例: (nvim), (lazygit), (yazi)。

			# format
			- <description> (<scope>)

			# example commit messages
			- 自動コミットの機能を追加した (lazygit)
			- IMEの切り替えを自動で行うようにした (nvimm)
			- LspInfoのコマンド作った (nvim)
			- yaziのnordフレーバーを入れた (yazi)
			- コードのフォーマットをした (aerospace)
			- パッケージの更新をした (nix)

			${type} ${diff}
			`;
		},
		themeColorCode: "",
		scopes: [],
		allowCustomScopes: true,
		allowEmptyScopes: true,
		customScopesAlign: "bottom",
		customScopesAlias: "custom",
		emptyScopesAlias: "empty",
		upperCaseSubject: false,
		markBreakingChangeMode: false,
		allowBreakingChanges: ["feat", "fix"],
		breaklineNumber: 100,
		breaklineChar: "|",
		skipQuestions: [],
		issuePrefixes: [
			{ value: "closed", name: "closed:   ISSUES has been processed" },
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
		formatMessageCB: ({ defaultMessage, type, scope, subject }) => {
			if (scope) {
				return `${type} ${subject} (${scope})`;
			}
			return `${type} ${subject}`;
		},
	},
};
