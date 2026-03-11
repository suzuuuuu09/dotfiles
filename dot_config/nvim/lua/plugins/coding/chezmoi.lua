---@module "lazy"
---@type LazyPluginSpec
return {
	"xvzc/chezmoi.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = true,
}
