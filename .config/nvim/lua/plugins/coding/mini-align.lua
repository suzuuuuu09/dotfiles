---@module "lazy"
---@type LazyPluginSpec
return {
	"nvim-mini/mini.nvim",
	main = "mini.align",
	keys = {
		{ "ga", mode = { "n", "v" }, desc = "Align" },
		{ "gA", mode = { "n", "v" }, desc = "Align (preview)" },
	},
	opts = function(_, opts)
		require("mini.align").setup({})
	end,
}

