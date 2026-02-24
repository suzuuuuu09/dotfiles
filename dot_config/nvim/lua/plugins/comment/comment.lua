return {
	"numToStr/Comment.nvim",
	dependencies = {
		"folke/ts-comments.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		-- prehook = require("ts-comments.comments").get(vim.bo.ft) or vim.bo.commentstring,
	},
}
