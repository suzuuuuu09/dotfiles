return {
	"max397574/better-escape.nvim",
	event = "InsertEnter",
	opts = {
		timeout = 700,
		default_mappings = false,
		mappings = {
			i = {
				j = {
					k = "<CMD>write<CR><Esc>",
					j = "<Esc>",
				},
			},
		},
	},
}
