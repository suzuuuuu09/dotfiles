---@module "lazy"
---@type LazyPluginSpec
return {
	"f-person/git-blame.nvim",
	enabled = false,
	event = { "BufReadPre", "BufNewFile" },
	config = true,
	keys = {
		{ "<leader>gb", "<cmd>GitBlameToggle<cr>", desc = "Toggle Git Blame" },
	},
}
