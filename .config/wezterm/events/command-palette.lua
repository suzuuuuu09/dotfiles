local wezterm = require("wezterm")
local act = wezterm.action

local shell = os.getenv("SHELL") or "/bin/zsh"

-- YaziやCodexなどの対話型コマンドをオーバーレイ表示する
local function spawn_overlay_pane(command)
	return wezterm.action_callback(function(window, pane)
		local new_pane = pane:split({
			direction = "Bottom",
			size = 1,
			args = {
				shell,
				"-l",
				"-c",
				command,
			},
		})

		if new_pane then
			window:perform_action(act.TogglePaneZoomState, new_pane)
		end
	end)
end

-- gh browseなど、画面表示が不要なコマンドを実行する
local function run_background(command)
	return wezterm.action_callback(function(window, pane)
		local cwd = pane:get_current_working_dir()

		if not cwd or cwd.scheme ~= "file" then
			window:toast_notification(
				"WezTerm",
				"現在のディレクトリを取得できませんでした",
				nil,
				3000
			)
			return
		end

		wezterm.background_child_process({
			shell,
			"-l",
			"-c",
			string.format("cd %s && %s", wezterm.shell_quote_arg(cwd.file_path), command),
		})
	end)
end

wezterm.on("augment-command-palette", function()
	return {
		{
			brief = "GitHub: Open repository (gh browse)",
			icon = "md_github",
			action = run_background("gh browse"),
		},
		{
			brief = "Launch: Lazygit (lg)",
			icon = "md_git",
			action = spawn_overlay_pane("lazygit"),
		},
		{
			brief = "Launch: Yazi (y)",
			icon = "md_folder",
			action = spawn_overlay_pane("yazi"),
		},
		{
			brief = "Launch: Codex",
			icon = "md_robot",
			action = spawn_overlay_pane("codex"),
		},
		{
			brief = "Launch: Resume (codex resume)",
			icon = "md_history",
			action = spawn_overlay_pane("codex resume"),
		},
	}
end)
