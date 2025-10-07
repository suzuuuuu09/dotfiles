local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font = wezterm.font("UDEV Gothic 35NFLG", { weight = "Regular" })
config.font_size = 16.0 -- フォントサイズの設定
config.use_ime = true -- IMEを有効にする
config.window_background_opacity = 0.80 -- ウィンドウの透明度の設定
config.macos_window_background_blur = 20 -- ぼかし

config.window_decorations = "RESIZE" -- タイトルバーを削除
-- config.hide_tab_bar_if_only_one_tab = true -- タブが一つしかない時に削除

config.window_frame = {
	inactive_titlebar_bg = "none",
	active_titlebar_bg = "none",
	border_left_width = "0.5cell",
	border_right_width = "0.5cell",
	border_bottom_height = "0.25cell",
	border_top_height = "0.25cell",
	border_left_color = "#88c0d0",
	border_right_color = "#88c0d0",
	border_bottom_color = "#88c0d0",
	border_top_color = "#88c0d0",
}

config.window_background_gradient = {
	colors = { "#2e3440" },
}

config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false

config.colors = {
	tab_bar = {
		inactive_tab_edge = "none",
	},
}

local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local background = "#5c6d74"
	local foreground = "#FFFFFF"
	local edge_background = "none"

	if tab.is_active then
		background = "#ae8b2d"
		foreground = "#FFFFFF"
	end

	local edge_foreground = background
	local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "

	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
	}
end)

-- 最初からフルスクリーンで起動
-- local mux = wezterm.mux
-- wezterm.on("gui-startup", function(cmd)
-- 	local tab, pane, window = mux.spawn_window(cmd or {})
-- 	window:gui_window():toggle_fullscreen()
-- end)

config.color_scheme = "nord"

return config
