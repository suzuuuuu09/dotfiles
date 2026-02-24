return {
	"Bekaboo/dropbar.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {},
	keys = {
		{
			"g;",
			function()
				require("dropbar.api").pick() -- 関数内でrequireする
			end,
			desc = "Pick symbols in winbar",
		},
		{
			"<leader>ub",
			function()
				Snacks.toggle
						.new({
							name = "Breadcrumbs",
							get = function()
								return vim.wo.winbar ~= ""
							end,
							set = function()
								-- dropbar.nvim に BreadcrumbsToggle コマンドがある、
								-- または自作コマンドがある前提です
								vim.cmd("BreadcrumbsToggle")
							end,
						})
						:toggle()
			end,
			desc = "Toggle Breadcrumbs",
		},
	},
}
