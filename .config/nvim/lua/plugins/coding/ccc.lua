---@module "lazy"
---@type LazyPluginSpec
return {
	"uga-rosa/ccc.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		highlighter = {
			auto_enable = false,
			lsp = true,
		},
	},
	keys = {
		{ "<leader>Cc", "<CMD>CccConvert<CR>", desc = "Convert color" },
		{ "<leader>Cp", "<CMD>CccPick<CR>", desc = "Pick color" },
	},
}
