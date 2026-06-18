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
				name: "✨  feat:     新機能の追加",
				emoji: "✨",
				title: "Features",
				description: "Add new features to the codebase.",
			},
			{
				value: "fix",
				name: "🐛  fix:      バグ修正",
				emoji: "🐛",
				title: "Bug Fixes",
				description: "Fix bugs in the codebase.",
			},
			{
				value: "docs",
				name: "📝  docs:     ドキュメントの生成や修正",
				emoji: "📝",
				title: "Documentation",
				description:
					"Add or update documentation (README, inline comments, etc.).",
			},
			{
				value: "style",
				name: "💄  style:    コードの意味に影響を与えない変更",
				emoji: "💄",
				title: "Code Style Improvements",
				description:
					"Improve code formatting, white spaces, semicolons, or UI appearance without changing behavior.",
			},
			{
				value: "refactor",
				name: "♻️   refactor: コードのパターンの変更や整理",
				emoji: "♻️",
				title: "Refactoring",
				description:
					"Refactor code without changing its behavior or fixing bugs.",
			},
			{
				value: "test",
				name: "✅  test:     テストコードの追加や修正",
				emoji: "✅",
				title: "Tests",
				description: "Add or update test codes.",
			},
			{
				value: "chore",
				name: "🔧  chore:    設定ファイルや開発環境の変更など",
				emoji: "🔧",
				title: "Chores",
				description:
					"Update build process, auxiliary tools, configuration files, etc. (non-source code).",
			},
			{
				value: "perf",
				name: "⚡️  perf:     パフォーマンスを向上させるためのコード変更",
				emoji: "⚡️",
				title: "Performance Improvements",
				description: "Improve the performance of the codebase.",
			},
			{
				value: "revert",
				name: "⏪️  revert:   コミットの打ち消し",
				emoji: "⏪️",
				title: "Reverts",
				description: "Revert to a previous commit.",
			},
			{
				value: "deps",
				name: "📦  deps:     依存関係・パッケージの追加や更新",
				emoji: "📦",
				title: "Dependencies",
				description: "Add or update dependencies and packages.",
			},
		],

		useEmoji: true,
		emojiAlign: "center",

		useAI: false,
		aiNumber: 5,

		aiQuestionCB: ({ type, diff, maxSubjectLength }) => {
			return `
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
