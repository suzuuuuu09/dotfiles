return {
	"folke/which-key.nvim",
	event = "VimEnter",
	dependencies = {
		"nvim-mini/mini.icons",
		"nvim-tree/nvim-web-devicons",
	},
	---@module "which-key"
	---@class wk.Opts
	opts = function()
		local icons = require("user.icons").wk
		return {
			preset = "helix",
			win = {
				wo = {
					winblend = 0,
				},
			},
			spec = {
				-- ╭─────────────────────────────────────────────────────────╮
				-- │               Fuzzy Finder (snacks.nvim)                │
				-- ╰─────────────────────────────────────────────────────────╯
				{ "<leader>f", group = "Find" },
				{ "<leader>ff", icon = icons.file_icon },
				{ "<leader>fF", icon = icons.hidden_file_icon },
				{ "<leader>fb", icon = icons.buffer_icon },
				{ "<leader>fm", icon = icons.mark_icon },
				{ "<leader>fh", icon = icons.help_icon },

				{ "<leader>g", group = "Git" },
				{ "<leader>l", group = "LSP", icon = " " },
				{ "<leader>b", group = "Buffer", icon = icons.buffer_icon },
				{ "<leader>d", group = "Debug" },
				{ "<leader>t", group = "Terminal" },
				{ "<leader>ti", group = "Terminal by ID" },
				{ "gcb", group = "Comment Box" },
				{ "<leader>R", group = "Kulala", icon = "󱜿 " },
				{ "<leader>t", group = "Terminal" },
				{ "<leader>ti", group = "Terminal by ID" },
				{ "<leader>r", group = "Run", icon = " " },
				{ "<leader>u", group = "UI", icon = " " },
			},
		}
	end,
}
