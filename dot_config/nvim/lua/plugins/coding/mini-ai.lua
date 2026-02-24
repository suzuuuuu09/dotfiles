---@module "lazy"
---@type LazyPluginSpec
return {
	"nvim-mini/mini.nvim",
	main = "mini.ai",
	keys = {
		{ "a", mode = { "o", "v" } },
		{ "i", mode = { "o", "v" } },
	},
	opts = function(_, opts)
		require("mini.ai").setup({})
	end,
}

