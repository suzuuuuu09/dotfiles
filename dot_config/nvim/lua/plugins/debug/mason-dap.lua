return {
	-- Mason DAP bridge
	"jay-babu/mason-nvim-dap.nvim",
	dependencies = {
		"mason-org/mason.nvim",
		"mfussenegger/nvim-dap",
	},
	opts = {
		ensure_installed = {
			"python",
			"lua",
		},
	},

}
