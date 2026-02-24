---@module "lazy"
---@type LazyPluginSpec
return {
	"hedyhli/outline.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"neovim/nvim-lspconfig",
	},
	cmd = { "Outline", "OutlineOpen" },
	---@module "outline"
	opts = {
		preview_window = {
			auto_preview = true,
		},
	},
	keys = {
		{ "<leader>lS", "<CMD>Outline<CR>", desc = "Symbols outline" },
	},
}
