return {
	"mistweaverco/kulala.nvim",
	ft = {
		"http",
		"graphql",
		"rest",
	},
	config = true,
	opts = {
		global_keymaps = false,
		global_keymaps_prefix = "<leader>R",
	},
	keys = {
		{
			"<leader>Rs",
			function()
				require("kulala").run()
			end,
			desc = "Send request",
		},
		{
			"<leader>Ra",
			function()
				require("kulala").run_all()
			end,
			desc = "Send all requests",
		},
		{
			"<leader>Rr",
			function()
				require("kulala").replay()
			end,
			desc = "Replay last request",
		},
		{
			"<leader>Rb",
			function()
				require("kulala").open_scratchpad()
			end,
			desc = "Open scratchpad",
		},
	},
}
