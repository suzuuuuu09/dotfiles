---@module "lazy"
---@type LazyPluginSpec
return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = "markdown",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-mini/mini.nvim",
	},
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {},
}
