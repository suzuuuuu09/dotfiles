return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	---@module "gitsigns"
	---@type Gitsigns.Config
	opts = {
		current_line_blame = true,
	},
}
