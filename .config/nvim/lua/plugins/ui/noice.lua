-- https://github.com/folke/noice.nvim
return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = function(_, opts)
		opts.routes = opts.routes or {}

		table.insert(opts.routes, {
			filter = {
				event = "notify",
				find = "No information available",
			},
			opts = { skip = true },
		})

		opts.presets = opts.presets or {}
		opts.presets.lsp_doc_border = true

		return opts
	end,
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
}
