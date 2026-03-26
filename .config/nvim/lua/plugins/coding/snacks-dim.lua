return {
	"folke/snacks.nvim",
	---@module "snacks"
	---@type snacks.Config.base
	opts = {
		---@type snacks.dim.Config
		dim = {
			enabled = true,
			scope = {
				min_size = 5,
				max_size = 40,
				siblings = true,
			},
		},
	},
	keys = {
		{
			"<leader>ud",
			function()
				Snacks.toggle
					.new({
						name = "Dim Background",
						get = function()
							return Snacks.dim.enabled
						end,
						set = function(state)
							if state then
								print("Enabling Dim!")
								Snacks.dim.enable()
							else
								print("Disabling Dim!")
								Snacks.dim.disable()
							end
						end,
					})
					:toggle()
			end,
			desc = "Toggle Dim",
		},
	},
}
