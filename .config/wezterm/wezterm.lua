local wezterm = require("wezterm")

-- ~/.config/wezterm 配下の分割設定を require できるようにする
package.path = wezterm.config_dir .. "/?.lua;" .. wezterm.config_dir .. "/?/init.lua;" .. package.path

require("events.command-palette")

---@type Nord.Palette
local nord = require("nord")
local config = wezterm.config_builder()

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

-- タブバーを背景色に合わせる
config.window_background_gradient = {
	colors = { nord.polar_night.origin },
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
