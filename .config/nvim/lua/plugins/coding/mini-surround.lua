---@module "lazy"
---@type LazyPluginSpec
return {
	"nvim-mini/mini.nvim",
	keys = {
		{ "sa" },
		{ "sd" },
		{ "sf" },
		{ "sF" },
		{ "sh" },
		{ "sr" },
	},
	opts = function(_, otps)
		require("mini.surround").setup({
			mappings = {
				add = "sa",    -- Add surrounding in Normal and Visual modes
				delete = "sd", -- Delete surrounding
				find = "sf",   -- Find surrounding (to the right)
				find_left = "sF", -- Find surrounding (to the left)
				highlight = "sh", -- Highlight surrounding
				replace = "sr", -- Replace surrounding

				suffix_last = "l", -- Suffix to search with "prev" method
				suffix_next = "n", -- Suffix to search with "next" method
			},
		})
	end,
}
