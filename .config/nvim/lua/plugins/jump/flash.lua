return {
	"folke/flash.nvim",
	event = { "BufReadPre", "BufNewFile" },
	---@module "flash"
	---@type Flash.Config
	opts = {
		modes = {
			char = { enable = false },
			search = { enable = false },
			treesitter = { enable = false },
		},
	},
	keys = {
		{
			"<CR>",
			mode = { "n", "x", "o", "v" },
			function()
				require("flash").jump({
					label = { before = true, after = false },
				})
			end,
		},
	},
}
