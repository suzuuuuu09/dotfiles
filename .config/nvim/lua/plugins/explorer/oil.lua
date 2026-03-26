---@module 'lazy'
---@type LazyPluginSpec
return {
	"stevearc/oil.nvim",
	-- NOTE: 遅延読み込みをするとパスを指定して実行すると開かなくなる
	lazy = false,
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		view_options = {
			show_hidden = true,
		},
		-- float = {
		--   padding = 2,
		--   max_height = 40,
		--   max_width = 0.8,
		--   border = "rounded",
		--   preview_split = "right",
		-- },
		keymaps = {
			["q"] = "actions.close",
		},
	},
	keys = {
		{ "<leader>o", "<CMD>Oil<CR>", desc = "Open File Explorer" },
	},
	dependencies = {
		{ "nvim-tree/nvim-web-devicons", opts = {} },
	},
}
