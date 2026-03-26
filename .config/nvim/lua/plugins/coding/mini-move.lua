---@module "lazy"
---@type LazyPluginSpec
return {
	"nvim-mini/mini.nvim",
	main = "mini.move",
	keys = {
		{ "<M-h>", mode = { "n", "v" }, desc = "Move selection left" },
		{ "<M-j>", mode = { "n", "v" }, desc = "Move selection down" },
		{ "<M-k>", mode = { "n", "v" }, desc = "Move selection up" },
		{ "<M-l>", mode = { "n", "v" }, desc = "Move selection right" },
	},
---@diagnostic disable-next-line: unused-local
	opts = function(_, opts)
		require("mini.move").setup({
			mappings = {
				left = "<M-h>",
				down = "<M-j>",
				up = "<M-k>",
				right = "<M-l>",
				line_left = "<M-h>",
				line_down = "<M-j>",
				line_up = "<M-k>",
				line_right = "<M-l>",
			},
		})
	end,
}

