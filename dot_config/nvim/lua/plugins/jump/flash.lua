return {
	"folke/flash.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		modes = {
			char = { enable = false },
			search = { enable = false },
			treesitter = { enable = false },
		}
	},
	keys = {
		{
			"<CR>",
			function ()
				require("flash").jump({
					label = { before = true, after = false }
				})
			end
		}
	}
}
