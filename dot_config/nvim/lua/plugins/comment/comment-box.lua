return {
	"LudoPinelli/comment-box.nvim",
	cmd = { "CBllbox", "CBllline", "CBd" },
	event = { "BufReadPre", "BufNewFile" },
	config = true,
	keys = {
		{ mode = { "n", "v" }, "gcbt", "<CMD>CBlcbox<CR>",  desc = "Box title" },
		{ mode = { "n", "v" }, "gcbl", "<CMD>CBllline<CR>", desc = "Title line" },
		{ mode = { "n", "v" }, "gcbd", "<CMD>CBd<CR>",      desc = "Remove comment box" },
	},
}
