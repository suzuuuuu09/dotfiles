---@module "lazy"
---@type LazyPluginSpec
return {
	"nvim-treesitter/nvim-treesitter-context",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		max_lines = 5,
	},
}
