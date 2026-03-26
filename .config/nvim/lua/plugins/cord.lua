return {
	"vyfor/cord.nvim",
	event = "VeryLazy",
	enabled = false,
	opts = {
		user_stub = false,           -- Discordのユーザー名を表示するか
		display = {
			show_time = true,          -- 経過時間を表示
			show_repository = true,    -- リポジトリ名を表示
			show_cursor_position = false, -- 行番号などを隠す（プライバシー配慮）
		},
		idle = {
			enabled = true, -- 放置検知を有効化
			timeout = 300000, -- 5分操作がないとIdle状態へ
			show_status = true,
		},
	},
}
