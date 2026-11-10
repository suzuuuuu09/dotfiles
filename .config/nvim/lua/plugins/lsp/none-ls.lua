return {
	"nvimtools/none-ls.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvimtools/none-ls-extras.nvim" },
	},
	opts = function()
		return {
			sources = {
				require("none-ls.diagnostics.cpplint"),
			},
		}
	end,
}
