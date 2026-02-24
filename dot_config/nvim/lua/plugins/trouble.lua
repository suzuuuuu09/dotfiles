return {
	"folke/trouble.nvim",
	cmd = "Trouble",
	---@class trouble.Config
	opts = {
		modes = {
			lsp = {
				win = {
					type = "split", -- split window
					relative = "win", -- relative to current window
					position = "right", -- right side
					size = 0.3,    -- 30% of the window
				},
			},
		},
	},
	keys = {
		{
			"<leader>xq",
			"<CMD>Trouble quickfix<CR>",
			desc = "Open Quickfix",
		},
		{
			"<leader>xl",
			"<CMD>Trouble loclist<CR>",
			desc = "Open Location List",
		},
	},
}
