---@module "lazy"
---@type LazyPluginSpec
return {
	"nvim-mini/mini.nvim",
	main = "mini.ai",
	keys = {
		{ "a", mode = { "o", "v" } },
		{ "i", mode = { "o", "v" } },
	},
	opts = function()
		local ai = require("mini.ai")
		return {
			n_lines = 500,
			custom_textobjects = {
				f = ai.gen_spec.treesitter({
					a = { "@function.outer", "@assignment.outer" },
					i = { "@function.inner", "@assignment.inner" },
				}),
				t = ai.gen_spec.treesitter({
					a = "@tag.outer",
					i = "@tag.inner",
				}),
				v = ai.gen_spec.treesitter({
					a = "@assignment.outer",
					i = "@assignment.inner",
				}),
			},
		}
	end,
	config = function(_, opts)
		require("mini.ai").setup(opts)
	end,
}
