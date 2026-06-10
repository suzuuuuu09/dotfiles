---@module "lazy"
---@type LazyPluginSpec
return {
	"obsidian-nvim/obsidian.nvim",
	enabled = false,
	opts = {
		legacy_commands = false,
		workspaces = {
			{
				name = "main",
				path = "~/Documents/Obsidian",
			},
		},
	},
}
