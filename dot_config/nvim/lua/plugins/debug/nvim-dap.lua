return {
	"mfussenegger/nvim-dap",
	dependencies = {
		-- "theHamsta/nvim-dap-virtual-text",
		-- "nvim-telescope/telescope-dap.nvim",
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio"
	},
	config = function ()
		local dap = require("dap")
		local dapui = require("dapui")

		dapui.setup()

		local set = vim.keymap.set

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		set("n", "<F5>", dap.continue, { desc = "Start / Continue" })
		set("n", "<leader>dc", dap.continue, { desc = "Start / Continue" })
		set("n", "<F6>", dap.pause, { desc = "Pause" })
		set("n", "<leader>dp", dap.pause, { desc = "Pause" })
	end
}
