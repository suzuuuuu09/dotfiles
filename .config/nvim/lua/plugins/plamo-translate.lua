---@module "lazy"
---@type LazyPluginSpec
return {
	"mozumasu/plamo-translate.nvim",
	cmd = {
		"PlamoTranslate",
		"PlamoTranslateReplace",
		"PlamoTranslateLine",
		"PlamoTranslateWord",
		"PlamoTranslateComments",
		"PlamoTranslateCommentsClear",
		"PlamoTranslateCommentsToggle",
	},
	keys = {
		{ "<leader>Tt", "<CMD>PlamoTranslate<CR>", mode = "n", desc = "Translate text (interactive)" },
		{ "<leader>Tt", ":'<,'>PlamoTranslate<CR>", mode = "v", desc = "Translate selected text" },
		{ "<leader>Tr", ":'<,'>PlamoTranslateReplace<CR>", mode = "v", desc = "Replace with translation" },
		{ "<leader>Tl", "<CMD>PlamoTranslateLine<CR>", mode = "n", desc = "Translate current line" },
		{ "<leader>Tw", "<CMD>PlamoTranslateWord<CR>", mode = "n", desc = "Translate word under cursor" },
		{ "<leader>Tc", "<CMD>PlamoTranslateCommentsToggle<CR>", mode = "n", desc = "Toggle comment translations" },
	},
	opts = {
		cli = {
			cmd = { "plamo-translate", "--no-stream" },
			from = "Auto",
			to = "Auto",
		},
		window = {
			default_display = "popup",
		},
	},
}
