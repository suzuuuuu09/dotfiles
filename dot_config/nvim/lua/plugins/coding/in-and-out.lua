return {
	"ysmb-wtsg/in-and-out.nvim",
	event = "InsertEnter",
	opts = {},
	keys = {
		{
			"<C-CR>",
			mode = "i",
			function()
				require("in-and-out").in_and_out()
			end,
		},
	},
}
