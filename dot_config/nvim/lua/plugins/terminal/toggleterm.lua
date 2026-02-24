return {
	"akinsho/toggleterm.nvim",
	event = "VeryLazy",
	version = "*",
	cmd = "ToggleTerm",
	config = function()
		---@module "toggleterm"
		---@class ToggleTermConfig
		require("toggleterm").setup({
			shell = vim.o.shell, -- change the default shell
		})
		local opts = { buffer = 0 }
		local keymap = vim.keymap

		keymap.set("t", "<ESC>", [[<C-\><C-n>]], opts)
		keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], opts)
		keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], opts)
		keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], opts)
		keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], opts)
	end,
	keys = function()
		-- Open Lazygit in a floating terminal
		local Terminal = require("toggleterm.terminal").Terminal
		local lazygit = Terminal:new({
			cmd = "lazygit",
			direction = "float",
			float_opts = { border = "curved" },
			hidden = true,
		})
		function _lazygit_toggle()
			lazygit:toggle()
		end

		-- Open a terminal by entering its ID
		local function open_terminal_by_id(direction, size)
			return function()
				vim.ui.input({ prompt = "(toggleterm.nvim) Terminal ID: " }, function(input)
					if input and input ~= "" then
						local size_opt = size and (" size=" .. size) or ""
						vim.cmd("ToggleTerm " .. input .. size_opt .. " direction=" .. direction)
					end
				end)
			end
		end

		return {
			{ "<leader>tf",  "<CMD>ToggleTerm direction=float<CR>",              desc = "Open floating terminal" },
			{ "<leader>th",  "<CMD>ToggleTerm size=10 direction=horizontal<CR>", desc = "Open horizontal terminal" },
			{ "<leader>tv",  "<CMD>ToggleTerm size=80 direction=vertical<CR>",   desc = "Open vertical terminal" },
			{ "<leader>gg",  "<CMD>lua _lazygit_toggle()<CR>",                   desc = "Open Lazygit" },
			{ "<leader>tl",  "<CMD>lua _lazygit_toggle()<CR>",                   desc = "Open Lazygit" },
			{ "<leader>tiv", open_terminal_by_id("vertical", 80),                desc = "Vertical" },
			{ "<leader>tih", open_terminal_by_id("horizontal", 10),              desc = "Horizontal" },
			{ "<leader>tif", open_terminal_by_id("float", nil),                  desc = "Floating" },
		}
	end,
}
