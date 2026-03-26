local wezterm = require("wezterm")
---@type Nord.Palette
local nord = require("nord")
local config = wezterm.config_builder()

local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
tabline.setup({
	options = {
		theme_overrides = {
			tab = {
				active = { fg = nord.snow_storm.brightest, bg = nord.frost.ocean },
				inactive = { fg = nord.snow_storm.origin, bg = nord.polar_night.darkest },
				inactive_hover = { fg = nord.snow_storm.brightest, bg = nord.frost.ocean },
			},
		},
	},
})

-- shellをfishにする
config.default_prog = { "/etc/profiles/per-user/k25012kk/bin/fish", "-l" }
config.automatically_reload_config = true
config.font = wezterm.font("UDEV Gothic 35NFLG", {
	weight = "Regular",
	harfbuzz_features = { "liga=1", "clig=1", "calt=1" }, -- リガチャを有効にする
})
config.font_size = 14.5
config.use_ime = true
config.window_background_opacity = 0.6
config.macos_window_background_blur = 5
config.color_scheme = "nord"

----------------------------------------------------
-- Tab
----------------------------------------------------
-- タイトルバーを非表示
config.window_decorations = "RESIZE"
-- タブバーの表示
config.show_tabs_in_tab_bar = true
-- タブが一つの時は非表示
-- config.hide_tab_bar_if_only_one_tab = true
-- falseにするとタブバーの透過が効かなくなる
-- config.use_fancy_tab_bar = false

-- タブバーの透過
config.window_frame = {
	inactive_titlebar_bg = "none",
	active_titlebar_bg = "none",
}

-- タブバーを背景色に合わせる
config.window_background_gradient = {
	colors = { nord.polar_night.darkest },
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

-- タブの形をカスタマイズ
-- タブの左側の装飾
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
-- タブの右側の装飾
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

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

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local background = nord.frost.ocean
	local foreground = nord.snow_storm.origin
	local edge_background = "none"
	if tab.is_active then
		background = nord.frost.ocean
		foreground = nord.snow_storm.brightest
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

----------------------------------------------------
-- keybinds
----------------------------------------------------
config.disable_default_key_bindings = false
config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables
config.leader = { key = "p", mods = "CTRL", timeout_milliseconds = 2000 }

return config
