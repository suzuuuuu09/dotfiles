local logo = [[
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
░░    ░░░░░   ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
▒▒  ▒   ▒▒▒   ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
▒▒   ▒   ▒▒   ▒▒▒▒   ▒▒▒▒▒▒▒▒   ▒▒▒▒▒   ▒▒▒▒▒   ▒▒▒▒▒    ▒   ▒   ▒▒▒
▓▓   ▓▓   ▓   ▓▓  ▓▓▓   ▓▓▓   ▓▓   ▓▓▓   ▓▓▓   ▓▓   ▓▓   ▓▓  ▓▓   ▓▓
▓▓   ▓▓▓  ▓   ▓         ▓▓   ▓▓▓▓   ▓▓▓   ▓   ▓▓▓   ▓▓   ▓▓  ▓▓   ▓▓
▓▓   ▓▓▓▓  ▓  ▓  ▓▓▓▓▓▓▓▓▓▓   ▓▓   ▓▓▓▓▓     ▓▓▓▓   ▓▓   ▓▓  ▓▓   ▓▓
██   ██████   ███     ███████   █████████   █████   █    ██  ██   ██
████████████████████████████████████████████████████████████████████
]]

local subcommands = {
	"middleout --center-movement-speed 0.8 --full-movement-speed 0.2",
	"slide --merge --movement-speed 0.8",
	"beams --beam-delay 5 --beam-row-speed-range 20-60 --beam-column-speed-range 8-12",
}

math.randomseed(os.time())
local subcommand = subcommands[math.random(#subcommands)]
local cmd = {
	"sh",
	"-c",
	"echo -e "
	.. vim.fn.shellescape(vim.trim(logo))
	.. " | tte --anchor-canvas s "
	.. subcommand
	.. " --final-gradient-direction diagonal",
}

return {
	"folke/snacks.nvim",
	priority = 1000,
	opts = {
		---@class snacks.dashboard.Item
		dashboard = {
			sections = {
				{ section = "header" },
				-- { section = "terminal", cmd = cmd, height = 17, width = 100, padding = 1, indent = -4 },
				{ icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
				{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
				{ icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
				{ section = "startup" },
			},
			preset = {
				header = logo,
			},
		},
	},
}
