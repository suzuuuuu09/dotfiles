---@module "lazy"
---@type LazyPluginSpec
return {
	"nvimdev/lspsaga.nvim",
	enabled = false,
	event = "LspAttach",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {},
}
