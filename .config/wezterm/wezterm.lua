local wezterm = require("wezterm")

-- ~/.config/wezterm 配下の分割設定を require できるようにする
package.path = wezterm.config_dir .. "/?.lua;" .. wezterm.config_dir .. "/?/init.lua;" .. package.path

require("events.command-palette")

---@type Nord.Palette
local nord = require("nord")
local config = wezterm.config_builder()

----------------------------------------------------
-- マルチプレクサ（セッション永続化）の設定
----------------------------------------------------
-- Unix Domain Socketを定義
--[[ config.unix_domains = {
	{
		name = "unix",
	},
} ]]

-- 起動時に自動的に 'unix' ドメインに接続する
-- これにより、ウィンドウを閉じても次回起動時に前回の状態が復元されます
-- config.default_gui_startup_args = { "connect", "unix" }
-- shellをfishにする
if wezterm.target_triple:find("darwin") then
	config.default_prog = {
		"/etc/profiles/per-user/" .. os.getenv("USER") .. "/bin/fish",
		"-l",
	}
end

config.automatically_reload_config = true
config.font = wezterm.font_with_fallback({
	"UDEV Gothic 35NFLG",
	"Symbols Nerd Font Mono",
}, {
	weight = "Regular",
})
config.harfbuzz_features = { "liga", "clig", "calt" } -- リガチャを有効にする
config.font_size = 13
config.use_ime = true
config.scrollback_lines = 1000
config.window_background_opacity = 0.8
config.color_scheme = "nord"

-- ウィンドウのぼかし
if wezterm.target_triple:find("darwin") then
	config.macos_window_background_blur = 20
elseif wezterm.target_triple:find("linux") then
	config.wayland_window_background_blur = true
end
----------------------------------------------------
-- Tab
----------------------------------------------------
-- タイトルバーを非表示
config.window_decorations = "RESIZE"
-- タブバーの表示
config.enable_tab_bar = false
config.show_tabs_in_tab_bar = false
-- タブが一つの時は非表示
-- config.hide_tab_bar_if_only_one_tab = true
-- falseにするとタブバーの透過が効かなくなる
-- config.use_fancy_tab_bar = false

-- タブバーを背景色に合わせる
config.window_background_gradient = {
	colors = { nord.polar_night.origin },
}

-- タブの追加ボタンを非表示
config.show_new_tab_button_in_tab_bar = false
-- nightlyのみ使用可能
-- タブの閉じるボタンを非表示
config.show_close_tab_button_in_tabs = false

-- タブ同士の境界線を非表示
config.colors = {
	tab_bar = {
		inactive_tab_edge = "none",
	},
}

local border_color = nord.frost.ice

config.window_frame = {
	border_left_width = "0.8cell",
	border_right_width = "0.8cell",
	border_bottom_height = "0.3cell",
	border_top_height = "0.3cell",
	border_left_color = border_color,
	border_right_color = border_color,
	border_bottom_color = border_color,
	border_top_color = border_color,
}

----------------------------------------------------
-- keybinds
----------------------------------------------------
config.disable_default_key_bindings = false
config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables
config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 2000 }

return config
