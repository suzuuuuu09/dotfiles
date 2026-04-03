return {
	"vyfor/cord.nvim",
	event = "VeryLazy",
	enabled = true,
	---@module "cord"
	---@type CordConfig
	opts = {
		user_stub = false,          -- Discordのユーザー名を表示するか
		display = {
			show_cursor_position = true, -- 行番号などを隠す（プライバシー配慮）
			flavor = "accent",        -- "accent" | "default" | "minimal"
		},
	},
}
