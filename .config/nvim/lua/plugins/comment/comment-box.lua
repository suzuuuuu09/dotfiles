return {
	"LudoPinelli/comment-box.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = true,
	keys = {
		{ mode = { "n", "v" }, "gcbt", "<CMD>CBlcbox10<CR>", desc = "Box title" },
		{ mode = { "n", "v" }, "gcbl", "<CMD>CBllline<CR>", desc = "Title line" },
		{ mode = { "n", "v" }, "gcbd", "<CMD>CBd<CR>", desc = "Remove comment box" },
	},
}
